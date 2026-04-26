module GameState where
import World
import Utils
import Descriptions
import qualified Data.Map as M
import Data.List (find)

data GameState = GameState
    {
        currentLocation :: String,
        inventory :: [Object],
        hunger :: Int,
        world :: M.Map String Location,
        gameOver :: Bool,
        isQuit :: Bool,
        shelterClueFound :: Bool,
        scarecrowBuilt :: Bool,
        stairsBuilt :: Bool,
        dogDistracted :: Bool,
        eagleDistracted :: Bool
    }

maxHunger :: Int
maxHunger = 12

maxInventory :: Int
maxInventory = 3

initialGame :: GameState
initialGame = GameState
    {
        currentLocation = "start_cage",
        inventory = [],
        hunger = 0,
        world = allLocationsMap,
        gameOver = False,
        isQuit = False,
        shelterClueFound = False,
        scarecrowBuilt = False,
        stairsBuilt = False,
        dogDistracted = False,
        eagleDistracted = False
    }


getCurrentLocation :: GameState -> Location
getCurrentLocation gs =
    world gs M.! currentLocation gs

getLocationData :: String -> GameState -> Location
getLocationData locName gs =
    case M.lookup locName (world gs) of
        Just loc -> loc
        Nothing  -> Location "empty" [] []

isWin :: GameState -> Bool
isWin gs = currentLocation gs == "home"

describeLocation :: String -> IO ()
describeLocation locName =
    case M.lookup locName locDescriptions of
        Nothing -> putStrLn "You see nothing special here."
        Just linesOfText -> printLines linesOfText

noticeObjects :: Location -> IO ()
noticeObjects location =
    let objs = objects location
    in
    if null objs
        then putStrLn "There is nothing interesting here."
        else mapM_ (\obj -> putStrLn $ "There is a " ++ objName obj ++ " here.") objs

getLocation :: String -> Location
getLocation locName =
    case M.lookup locName allLocationsMap of
        Just loc -> loc
        Nothing  -> error $ "Location not found: " ++ locName

addObjectToLocation :: String -> Object -> GameState -> GameState
addObjectToLocation locName obj gs =
    let loc = (world gs) M.! locName
        newLoc = loc { objects = obj : (objects loc) }
    in gs { world = M.insert locName newLoc (world gs) }

removeObjectFromLocation :: String -> Object -> GameState -> GameState
removeObjectFromLocation locName obj gs =
    let worldMap = world gs
        loc = worldMap M.! locName
        newLoc = loc { objects = deleteObject (objName obj) (objects loc) }
    in gs { world = M.insert locName newLoc worldMap }

getInventory :: GameState -> IO ()
getInventory gs = do
    let inv = inventory gs
    putStrLn "Muffin is carrying:"
    if null inv
        then putStrLn "Nothing. Her mouth is empty."
        else do
            mapM_ (\obj -> putStrLn $ "- " ++ objName obj) inv
            putStrLn "That is everything in her mouth."

addFromLocToInventory :: Object -> GameState -> GameState
addFromLocToInventory obj gs =
    let gsUpdate = removeObjectFromLocation (currentLocation gs) obj gs
    in gsUpdate { inventory = obj : inventory gsUpdate }

removeFromInventoryToLoc :: Object -> GameState -> GameState
removeFromInventoryToLoc obj gs =
    let newInventory = deleteObject (objName obj) (inventory gs)
        gsUpdate = gs { inventory = newInventory }
    in addObjectToLocation (currentLocation gs) obj gsUpdate

increaseHunger :: GameState -> GameState
increaseHunger gs =
    let newHunger = hunger gs + 1
        isMax = newHunger >= maxHunger
    in gs { hunger = newHunger, gameOver = isMax }

tryTake :: Object -> GameState -> IO GameState
tryTake obj gs
    | objName obj `elem` ["dog", "river", "sofa"] = do
        getTakeMessage (objName obj)
        return gs
    | objName obj == "white_rock" = do
        putStrLn "You pick up the white_rock."
        putStrLn "Something was underneath... a hat!"

        let gsRemove = removeObjectFromLocation (currentLocation gs) obj gs
        let gsAdd = addObjectToLocation (currentLocation gs) hat gsRemove
        let emptyRock = obj { contains = [] }
        return $ addFromLocToInventory emptyRock gsAdd

    | otherwise = do
        putStrLn $ "You picked up " ++ objName obj ++ "."
        return $ addFromLocToInventory obj gs

tryEat :: String -> GameState -> GameState
tryEat itemName gs
    | itemName == "catnip" || itemName == "chocolate" =
        gs { gameOver = True }
    | itemName `elem` fish =
        gs { hunger = max 0 (hunger gs - 3) }
    | itemName `elem` rodents =
        gs { hunger = max 0 (hunger gs - 2) }
    | otherwise = gs


tryMove :: Direction -> Location -> GameState -> IO GameState
tryMove dir location gs =
    case lookup dir (exits location) of
        Nothing -> do
            case getOutOfBoundsMessage gs of
                Just msg -> printLines msg
                Nothing  -> putStrLn "\nMuffin cannot go that way.\n"
            return gs

        Just newLocation -> do
            showHunger gs
            describeLocation newLocation
            let newLocData = getLocationData newLocation gs
            noticeObjects newLocData

            return gs { currentLocation = newLocation }


tryAttach :: String -> String -> String -> GameState -> IO GameState
tryAttach item baseName result gs = do
    let locName = currentLocation gs
    let loc = getCurrentLocation gs

    case M.lookup result buildMessages of
        Just msg -> printLines msg
        Nothing  -> return ()

    let maybeObj = find (\o -> objName o == baseName) (objects loc)

    case maybeObj of
        Nothing -> do
            return gs

        Just obj -> do
            let gsRemove = removeObjectFromLocation locName obj gs
            let gsAdd = addObjectToLocation locName (Object result []) gsRemove

            let newInv = filter (\o -> objName o /= item) (inventory gsAdd)
            let gsInv = gsAdd { inventory = newInv }

            let finalGs = case result of
                    "scarecrow" -> gsInv { scarecrowBuilt = True }
                    "stairs"    -> gsInv { stairsBuilt = True }
                    _           -> gsInv

            return finalGs

solveShelterPuzzle :: GameState -> IO GameState
solveShelterPuzzle gs =
    if shelterClueFound gs
    then do
        putStrLn "You already solved this puzzle."
        return gs
    else do
        printLines shelterPuzzleText
        let newWorld = addObjectToLocation "rocky_road" shell gs
        return newWorld { shelterClueFound = True }

buildTotem :: GameState -> IO GameState
buildTotem gs = do
    printLines buildTotemText
    let newWorld = addObjectToLocation "waterfall" pipe gs
    return newWorld

showHunger :: GameState -> IO ()
showHunger gs =
    putStrLn $ "[hunger: " ++ show (hunger gs) ++ "/" ++ show maxHunger ++ "]"

checkEvent :: GameState -> Direction -> Maybe (EventResult, String)
checkEvent gs dir
    | currentLocation gs == "town" && dir == South && not (eagleDistracted gs) =
        Just (Death, "eagle_death")
    | currentLocation gs == "town" && dir == South && not (dogDistracted gs) =
        Just (Blocked, "dog_blocked")
    | currentLocation gs == "bridge" && dir == West && not (stairsBuilt gs) =
        Just (Blocked, "gate_blocked")
    | currentLocation gs == "bridge" && dir == West && stairsBuilt gs =
        Just (Success, "gate_unlocked")
    | currentLocation gs == "wheat_field" && dir == West && not (scarecrowBuilt gs) =
        Just (Blocked, "crows_blocked")
    | currentLocation gs == "car" =
        Just (Death, "car_death")
    | currentLocation gs == "forest" && dir == North =
        Just (Death, "lake_death")
    | currentLocation gs == "wheat_field" && dir == East =
        Just (Death, "lake_death")
    | currentLocation gs `elem` ["meadow", "rocky_road", "river"] && dir == South =
        Just (Death, "shelter_gameover")
    | otherwise = Nothing

getOutOfBoundsMessage :: GameState -> Maybe [String]
getOutOfBoundsMessage gs =
    M.lookup (currentLocation gs) outOfBoundsMessages