module Main where
import World
import Descriptions
import GameState
import Commands
import Utils
import qualified Data.Map as M
import System.IO (hSetBuffering, stdout, BufferMode(NoBuffering), hFlush)

printIntroduction = printLines introductionText
printInstructions = printLines instructionsText
printTitle = printLines titleText

readCommand :: IO String
readCommand = do
    putStr "> "
    hFlush stdout
    getLine

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
        ("arrange" : args) -> arrange args gs
        ["search", obj] -> searchObject obj gs
        ["instructions"] -> printInstructions >> return gs
        ["quit"] -> return gs { isQuit = True }
        _ -> putStrLn "Unknown command." >> return gs

gameLoop :: GameState -> IO ()
gameLoop gs
    | isQuit gs = do
        putStrLn "Goodbye!"
    | gameOver gs = do
        putStrLn "YOU LOSE."
    | isWin gs = do
        putStrLn "YOU WIN."
    | otherwise = do
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