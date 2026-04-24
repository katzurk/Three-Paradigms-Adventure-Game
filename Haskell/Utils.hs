module Utils where

import World
import Descriptions
import qualified Data.Map as M
import Data.List (find)

printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)

findObject :: String -> [Object] -> Maybe Object
findObject name = find (\o -> objName o == name)

deleteObject :: String -> [Object] -> [Object]
deleteObject name items = filter (\obj -> objName obj /= name) items

findObjectInLocation :: String -> Location -> Maybe Object
findObjectInLocation name loc =
    find (\o -> objName o == name) (objects loc)

getEatMessage :: String -> IO ()
getEatMessage key =
    case M.lookup key eatDescriptions of
        Just msg -> printLines msg
        Nothing  -> putStrLn ""