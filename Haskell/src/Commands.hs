module Commands where

import World
import Descriptions
import GameState
import Utils
import qualified Data.Map as M
import Data.List (find)

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

look :: GameState -> IO ()
look gs = do
    showHunger gs
    describeLocation (currentLocation gs)
    noticeObjects (getCurrentLocation gs)

showMouth :: GameState -> IO ()
showMouth gs = getInventory gs

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
                putStrLn "Muffin's mouth is full!"
                return gs
            else tryTake obj gs

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
            else if name `elem` fish then do
                putStrLn "An eagle swoops down and grabs the fish!"
                putStrLn "It flies away with its meal."
                let newInv = filter (\o -> objName o /= name) (inventory gs)
                return gs { eagleDistracted = True, inventory = newInv }
            else do
                putStrLn "Dropped."
                return $ removeFromInventoryToLoc obj gs

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
            (itemToDrop : remainingItems) -> do
                putStrLn $ "Muffin searches the " ++ name ++ " and finds a " ++ objName itemToDrop ++ "!"
                let gs1 = removeObjectFromLocation locName obj gs
                let updatedObj = obj { contains = remainingItems }

                let gs2 = addObjectToLocation locName updatedObj gs1
                let finalGs = addObjectToLocation locName itemToDrop gs2
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
            else if reqLoc /= "" && reqLoc /= locName then do
                putStrLn $ "You need to build the " ++ result ++ " near the " ++ reqLoc
                return gs
            else do
                tryAttach item base result gs

arrange :: [String] -> GameState -> IO GameState
arrange input gs
    | currentLocation gs == "rocky_road" && length input == 7 =
        if input == ["s","h","e","l","t","e","r"]
        then solveShelterPuzzle gs
        else do
            putStrLn "The stones do not seem to form a meaningful word."
            return gs
    | currentLocation gs == "waterfall" && length input == 4 = do
        let required = ["brick", "white_rock", "cool_pebble", "shell"]
        let locItems = objects (getCurrentLocation gs)
        let allPresent = all (\reqName -> any (\obj -> objName obj == reqName) locItems) required
        if not allPresent then do
            putStrLn "You do not have all the stones needed to build the totem."
            return gs
        else if input == ["b", "w", "c", "s"] then
            buildTotem gs
        else do
            putStrLn "That's not the right order or items for the totem."
            return gs
    | otherwise = do
        putStrLn "That arrangement makes no sense here."
        return gs