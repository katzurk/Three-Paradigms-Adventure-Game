module World where
import qualified Data.Map as M

data Direction = North | South | East | West
    deriving (Eq, Ord, Show)

data Location = Location
    {
        name :: String,
        objects :: [Object],
        exits :: [(Direction, String)]
    } deriving (Eq, Show)

data EventResult = Blocked | Death | Success

data Object = Object
    {
        objName :: String,
        contains :: [Object]
    }
    deriving (Eq, Show)

cage = Object "cage" [Object "hamster" []]
cardboardBox = Object "cardboard_box" [Object "cod" [], Object "mackerel" [], Object "roach" []]
pipe = Object "pipe" [Object "herring" []]
whiteRock = Object "white_rock" [Object "hat" [Object "berbil" []]]
hay = Object "hay" [Object "brown_mouse" []]
branch = Object "branch" [Object "squirrel" []]
brick = Object "brick" [Object "tiny_mouse" []]
catnip = Object "catnip" []
coolPebble = Object "cool_pebble" []
bigStick = Object "big_stick" []
brokenStool = Object "broken_stool" []
chocolate = Object "chocolate" []
hat = Object "hat" [Object "gerbil" []]
dog = Object "dog" []
rat = Object "rat" []
sofa = Object "sofa" []
bone = Object "bone" []
shell = Object "shell" []

fish = ["cod", "mackerel", "roach", "herring"]
rodents = ["hamster", "berbil", "brown_mouse", "tiny_mouse", "rat", "squirrel", "gerbil"]
special = ["chocolate", "catnip"]
allFood = fish ++ rodents ++ special

worldData :: [Location]
worldData =
    [ Location "start_cage" [cage]
        [(North, "forest"), (West, "road"), (East, "low_forest"), (South, "meadow")]

    , Location "forest" [cardboardBox, bigStick]
        [(North, "lake"), (West, "barn"), (East, "infinite_forest"), (South, "start_cage")]

    , Location "low_forest" [branch, Object "small_stick" []]
        [(North, "infinite_forest"), (West, "start_cage"), (East, "infinite_forest")]

    , Location "infinite_forest" []
        [(North, "infinite_forest"), (South, "infinite_forest"), (East, "infinite_forest"), (West, "infinite_forest")]

    , Location "road" [brokenStool, chocolate, sofa]
        [(North, "barn"), (East, "start_cage"), (West, "waterfall"), (South, "rocky_road")]

    , Location "rocky_road" []
        [(North, "road"), (West, "river"), (East, "meadow")]

    , Location "meadow" [whiteRock]
        [(North, "start_cage"), (West, "rocky_road"), (East, "infinite_forest")]

    , Location "waterfall" []
        [(East, "road"), (South, "river")]

    , Location "river" []
        [(North, "waterfall"), (East, "rocky_road")]

    , Location "wheat_field" [hay]
        [(West, "cabbage_field"), (South, "barn")]

    , Location "cabbage_field" []
        [(East, "wheat_field"), (West, "bridge"), (South, "car")]

    , Location "bridge" []
        [(East, "wheat_field"), (West, "town")]

    , Location "barn" [catnip, brick]
        [(North, "wheat_field"), (West, "car"), (East, "forest"), (South, "road")]

    , Location "car" [] []
    , Location "lake" [] []
    , Location "graveyard" [bone] [(East, "town")]
    , Location "town" [dog, rat] [(East, "bridge"), (West, "graveyard"), (South, "home")]
    , Location "home" [] []
    ]

allLocationsMap :: M.Map String Location
allLocationsMap = M.fromList [ (name l, l) | l <- worldData ]