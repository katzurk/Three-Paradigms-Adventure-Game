module GameState where
import World
import Descriptions
import qualified Data.Map as M

printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)

data GameState = GameState
    {
        currentLocation :: String,
        inventory :: [Object],
        hunger :: Int,
        world :: M.Map String Location,
        gameOver :: Bool,
        scarecrowBuilt :: Bool,
        stairsBuilt :: Bool
    }

maxHunger = 12
maxInventory = 3

initialGame :: GameState
initialGame = GameState
    {
        currentLocation = "start_cage",
        inventory = [],
        hunger = 0,
        world = allLocationsMap,
        gameOver = False,
        scarecrowBuilt = False,
        stairsBuilt = False
    }


getCurrentLocation :: GameState -> Location
getCurrentLocation gs =
    world gs M.! currentLocation gs

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

getInventory :: GameState -> IO ()
getInventory gs = do
    let inv = inventory gs
    putStrLn "Muffin is carrying:"
    if null inv
        then putStrLn "Nothing. Her mouth is empty."
        else do
            mapM_ (\obj -> putStrLn $ "- " ++ objName obj) inv
            putStrLn "That is everything in her mouth."

getLocation :: String -> Location
getLocation locName =
    case M.lookup locName allLocationsMap of
        Just loc -> loc
        Nothing  -> error $ "Location not found: " ++ locName

-- addObjectToLocation :: String -> GameState -> GameState

-- removeObjectFromLocation :: String -> GameState -> GameState

showHunger :: GameState -> IO ()
showHunger gs =
    putStrLn $ "[hunger: " ++ show (hunger gs) ++ "/" ++ show maxHunger ++ "]"

increaseHunger :: GameState -> GameState
increaseHunger gs =
    let newHunger = hunger gs + 1
        isMax = newHunger >= maxHunger
    in gs { hunger = newHunger, gameOver = isMax }


