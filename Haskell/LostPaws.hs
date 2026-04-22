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

findObject :: String -> [Object] -> Maybe Object
findObject name = find (\o -> objName o == name)

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
dropObject "bone" gs | currentLocation gs == "town" = do
    putStrLn "The dog grabs the bone and runs away happily!"
    return gs { dogDistracted = True, inventory = filter (\o -> objName o /= "bone") (inventory gs) }

dropObject objName gs =
    case findObject objName (inventory gs) of
        Nothing -> do
            putStrLn "You are not holding it."
            return gs
        Just obj -> do
            putStrLn "Dropped."
            let gsWithAddedItem = addObjectToLocation (currentLocation gs) obj gs
            let newInv = filter (/= obj) (inventory gs)
            return gsWithAddedItem { inventory = newInv }

showMouth :: GameState -> IO ()
showMouth gs =
    getInventory gs

look :: GameState -> IO ()
look gs = do
    showHunger gs
    describeLocation (currentLocation gs)
    noticeObjects (getCurrentLocation gs)

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

-- buildScarecrow :: GameState -> IO GameState
-- buildScarecrow gs = do
--     let invNames = map objName (inventory gs)
--     if "hat" `elem` invNames && "headless_man" `elem` map objName (objects (getCurrentLocation gs))
--         then do
--             putStrLn "You place the hat on top. The crows fly away!"
--             let gs1 = removeObjectFromLocation "wheat_field" (Object "headless_man" []) gs
--             return gs1 { scarecrowBuilt = True, inventory = filter (\o -> objName o /= "hat") (inventory gs) }
--         else do
--             putStrLn "Muffin doesn't have the right items or is in the wrong place."
--             return gs

readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

parseCommand :: String -> GameState -> IO GameState
parseCommand cmd gs =
    case words cmd of
        ["n"] -> move North gs
        ["s"] -> move South gs
        ["e"] -> move East gs
        ["w"] -> move West gs
        ["look"] -> look gs >> return gs
        ["inventory"] -> showMouth gs >> return gs
        ["take", item] -> takeObject item gs
        ["drop", item] -> dropObject item gs
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
            gameLoop gs'

main :: IO ()
main = do
    printTitle
    printIntroduction
    printInstructions

    showHunger initialGame
    describeLocation "start_cage"

    gameLoop initialGame