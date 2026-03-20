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
    let location = getCurrentLocation gs
    in
    case lookup dir (exits location) of
        Nothing -> do
            putStrLn "\nMuffin cannot go that way.\n"
            return gs

        Just newLocation -> do
            let newGs = increaseHunger gs
            showHunger newGs

            describeLocation newLocation
            noticeObjects (getLocation newLocation)
            return newGs { currentLocation = newLocation }

takeObject :: String -> GameState -> IO GameState
takeObject objName gs =
    let loc = getCurrentLocation gs
    in
    case findObject objName (objects loc) of
        Nothing -> do
            putStrLn $ "There is no " ++ objName ++ " here."
            return gs
        Just obj -> do
            let newLocObjects = filter (/= obj) (objects loc)
                newLoc = loc { objects = newLocObjects }
                newWorld = M.insert (currentLocation gs) newLoc (world gs)
                newInv = obj : inventory gs
            putStrLn $ "You picked up " ++ objName ++ "."
            return gs { world = newWorld, inventory = newInv }

dropObject :: String -> GameState -> IO GameState
dropObject objName gs =
    case findObject objName (inventory gs) of
        Nothing -> do
            putStrLn $ "You are not holding it."
            return gs
        Just obj -> do
            let newInv = filter (/= obj) (inventory gs)
                loc = getCurrentLocation gs
                newLocObjects = obj : objects loc
                newLoc = loc { objects = newLocObjects }
                newWorld = M.insert (currentLocation gs) newLoc (world gs)
            putStrLn $ "Dropped."
            return gs { world = newWorld, inventory = newInv }

showMouth :: GameState -> IO ()
showMouth gs =
    getInventory gs

look :: GameState -> IO ()
look gs = do
    showHunger gs
    describeLocation (currentLocation gs)
    noticeObjects (getCurrentLocation gs)

-- searchObject :: String -> GameState -> IO GameState
-- searchObject objName gs = do
--     let loc = getCurrentLocation gs
--     case findObject objName (objects loc) of
--         Nothing -> do
--             putStrLn "You find nothing here."
--             return gs
--         Just obj -> do
--             case contains obj of
--                 [] -> do
--                     putStrLn $ "Nothing else inside the " ++ objName ++ "."
--                     return gs
--                 items -> do
--                     -- Move all contained items to the location
--                     let newLocObjects = objects loc ++ items
--                         newLoc = loc { objects = newLocObjects }
--                         newWorld = M.insert (currentLocation gs) newLoc (world gs)
--                         -- Remove items from obj's contains (optional, to simulate emptying)
--                         emptiedObj = obj { contains = [] }
--                         finalLocObjects = emptiedObj : filter (/= obj) newLocObjects
--                         finalLoc = newLoc { objects = finalLocObjects }
--                         finalWorld = M.insert (currentLocation gs) finalLoc newWorld

--                     -- Print messages for each found item
--                     mapM_ (\item -> putStrLn $ "Muffin searches the " ++ objName ++ " and finds a " ++ objName item ++ "!") items

--                     return gs { world = finalWorld }

-- eatObject :: Object -> GameState -> IO GameState

-- attachObjects :: Object -> Object -> GameState -> IO GameState

-- arrangeLetters :: [Char] -> GameState -> IO GameState

-- arrangeObjects :: [Object] -> GameState -> IO GameState

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
        -- ["search", obj] -> searchObject obj gs
        ["instructions"] -> printInstructions >> return gs
        ["quit"] -> putStrLn "Goodbye!" >> return gs { gameOver = True }
        _ -> putStrLn "Unknown command." >> return gs

gameLoop :: GameState -> IO ()
gameLoop gs = do
    when (not $ gameOver gs) $ do
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