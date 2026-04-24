module LostPaws where
import World
import Descriptions
import GameState
import qualified Data.Map as M
import Data.List (find)
import Control.Monad (when)

printIntroduction = printLines introductionText
printInstructions = printLines instructionsText
printTitle = printLines titleText

move :: Direction -> GameState -> IO GameState
move dir gs =
    let gsHungry = increaseHunger gs

    in if gameOver gsHungry
        then do
            putStrLn "Muffin is too weak to take another step..."
            return gsHungry
        else do
            let location = getCurrentLocation gsHungry
            case checkEvent gsHungry dir of
                Just (Death, key) -> do
                    case M.lookup key conditionMessages of
                        Just msg -> printLines msg
                        Nothing  -> putStrLn "Game Over."
                    return gsHungry { gameOver = True }

                Just (Blocked, key) -> do
                    case M.lookup key conditionMessages of
                        Just msg -> printLines msg
                        Nothing  -> putStrLn "You can't go that way."
                    return gsHungry

                _ -> tryMove dir location gsHungry


takeObject :: String -> GameState -> IO GameState
takeObject objName gs =
    let loc = getCurrentLocation gs
    in case findObject objName (objects loc) of
        Nothing -> do
            putStrLn $ "There is no " ++ objName ++ " here."
            return gs
        Just obj ->
            if length (inventory gs) >= maxInventory
                    then do
                        putStrLn "Muffin's mouth is full! She can't carry anything else."
                        return gs
                    else do
                        putStrLn $ "You picked up " ++ objName ++ "."
                        let gsWithRemovedItem = removeObjectFromLocation (currentLocation gs) obj gs
                        return gsWithRemovedItem { inventory = obj : inventory gs }

dropObject :: String -> GameState -> IO GameState
dropObject name gs =
    case find (\o -> objName o == name) (inventory gs) of
        Nothing -> do
            putStrLn "You are not holding it."
            return gs
        Just obj -> do
            if name == "bone" && currentLocation gs == "town" then do
                putStrLn "The dog grabs the bone and runs away happily!"
                let newInv = filter (\o -> objName o /= "bone") (inventory gs)
                return gs { dogDistracted = True, inventory = newInv }
            else do
                putStrLn "Dropped."
                let gsWithAddedItem = addObjectToLocation (currentLocation gs) obj gs
                let newInv = filter (\o -> objName o /= name) (inventory gs)
                return gsWithAddedItem { inventory = newInv }

showMouth :: GameState -> IO ()
showMouth gs =
    getInventory gs

look :: GameState -> IO ()
look gs = do
    showHunger gs
    describeLocation (currentLocation gs)
    noticeObjects (getCurrentLocation gs)

eat :: String -> GameState -> IO GameState
eat foodName gs = do
    let inv = inventory gs
    case findObject foodName inv of
        Nothing -> do
            putStrLn "You are not holding it."
            return gs

        Just obj ->
            if not (foodName `elem` allFood) then do
                putStrLn $ "You cannot eat that."
                return gs
            else do
                let msgKey = if foodName `elem` special then foodName
                            else if foodName `elem` fish then "fish"
                            else if foodName `elem` rodents then "rodent"
                            else "default"
                getEatMessage msgKey

                let newInv = filter (\o -> objName o /= foodName) inv
                let gsRemoved = gs { inventory = newInv }
                let finalGs = tryEat foodName gsRemoved

                if not (gameOver finalGs) then do
                    showHunger finalGs
                    return finalGs
                else
                    return finalGs

searchObject :: String -> GameState -> IO GameState
searchObject "river" gs =
    if currentLocation gs == "river"
    then do
        putStrLn "Muffin splashes the water with her paw."
        putStrLn "She finds a shiny cool_pebble!"
        return (addObjectToLocation "river" coolPebble gs)
    else do
        putStrLn "There is no river here."
        return gs

searchObject name gs = do
    let loc = getCurrentLocation gs
    let locName = currentLocation gs

    case findObject name (objects loc) of
        Nothing -> do
            putStrLn "You find nothing here."
            return gs

        Just obj -> case contains obj of
            [] -> do
                putStrLn "Nothing else inside."
                return gs

            foundItems -> do
                putStrLn $ "Muffin searches the " ++ name ++ " and finds:"
                mapM_ (\i -> putStrLn $ "- " ++ objName i) foundItems

                let gs1 = removeObjectFromLocation locName obj gs
                let emptyObj = obj { contains = [] }
                let gs2 = addObjectToLocation locName emptyObj gs1

                let finalGs = foldl (\state item -> addObjectToLocation locName item state) gs2 foundItems

                return finalGs

attachObject :: String -> String -> GameState -> IO GameState
attachObject item base gs = do
    let inv = inventory gs
    let locName = currentLocation gs
    let locObjects = objects (getCurrentLocation gs)

    let recipe = find (\(i, b, _, _) -> i == item && b == base) buildRecipes

    case recipe of
        Nothing -> do
            putStrLn "Those things cannot be attached together."
            return gs

        Just (i, b, result, reqLoc) -> do
            let holdsItem = any (\o -> objName o == item) inv
            let baseIsHere = any (\o -> objName o == base) locObjects

            if not holdsItem then do
                putStrLn "You do not have that item."
                return gs
            else if not baseIsHere then do
                putStrLn "The second item is not here."
                return gs
            else if reqLoc /= locName then do
                putStrLn $ "You need to build this near the " ++ reqLoc
                return gs
            else do
                performAttach item base result gs


readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

parseCommand :: String -> GameState -> IO GameState
parseCommand cmd gs =
    case words cmd of
        ["move", "n"] -> move North gs
        ["move", "s"] -> move South gs
        ["move", "e"] -> move East gs
        ["move", "w"] -> move West gs
        ["look"] -> look gs >> return gs
        ["show", "mouth"] -> showMouth gs >> return gs
        ["take", item] -> takeObject item gs
        ["drop", item] -> dropObject item gs
        ["attach", a, b] -> attachObject a b gs
        ["eat", item] -> eat item gs
        -- ["arrange", a, b, c] -> arrangeObjects a b gs
        ["search", obj] -> searchObject obj gs
        ["instructions"] -> printInstructions >> return gs
        ["quit"] -> putStrLn "Goodbye!" >> return gs { gameOver = True }
        _ -> putStrLn "Unknown command." >> return gs

gameLoop :: GameState -> IO ()
gameLoop gs = do
    if gameOver gs
        then do
            putStrLn "YOU LOSE"
        else do
            cmd <- readCommand
            gs' <- parseCommand cmd gs
            putStrLn ""
            gameLoop gs'

main :: IO ()
main = do
    printTitle
    printIntroduction
    printInstructions

    showHunger initialGame
    describeLocation "start_cage"
    putStrLn ""

    gameLoop initialGame