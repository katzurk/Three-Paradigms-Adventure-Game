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
cardboardBox = Object "cardboard_box"
    [
        Object "cod" [],
        Object "mackerel" [],
        Object "roach" []
    ]

pipe = Object "pipe" [Object "herring" []]
whiteRock = Object "white_rock" [Object "hat" [Object "berbil" []]]
hay = Object "hay" [Object "brown_mouse" []]
branch = Object "branch" [Object "squirell" []]
brick = Object "brick" [Object "tiny_mouse" []]
catnip = Object "catnip" []
coolPebble = Object "cool_pebble" []
bigStick = Object "big_stick" []
brokenStool = Object "broken_stool" []
chocolate = Object "chocolate" []
dog = Object "dog" []
rat = Object "rat" []
sofa = Object "sofa" []
bone = Object "bone" []
shell = Object "shell" []

fish :: [String]
fish = ["cod", "mackerel", "roach", "herring"]

rodents :: [String]
rodents = ["hamster", "berbil", "brown_mouse", "tiny_mouse", "rat", "squirell"]

special :: [String]
special = ["chocolate", "catnip"]

allFood :: [String]
allFood = fish ++ rodents ++ special

startCage :: Location
startCage = Location "start_cage" [cage]
    [(North,"forest"), (West,"road"), (East,"low_forest"), (South,"meadow")]

forest :: Location
forest = Location "forest" [cardboardBox, bigStick]
    [(North,"lake"), (West,"barn"), (East,"infinite_forest"), (South,"start_cage")]

lowForest :: Location
lowForest = Location "low_forest" [branch, Object "small_stick" []]
    [(North,"infinite_forest"), (West,"start_cage"), (East,"infinite_forest")]

infiniteForest :: Location
infiniteForest = Location "infinite_forest" []
    [(North,"infinite_forest"), (South,"infinite_forest"), (East,"infinite_forest"), (West,"infinite_forest")]

road :: Location
road = Location "road" [brokenStool, chocolate, sofa]
    [(North,"barn"), (East,"start_cage"), (West,"waterfall"), (South,"rocky_road")]

rockyRoad :: Location
rockyRoad = Location "rocky_road" []
    [(North,"road"), (West,"river"), (East,"meadow"), (South,"shelter")]

meadow :: Location
meadow = Location "meadow" [whiteRock]
    [(North,"start_cage"), (West,"rocky_road"), (East,"infinite_forest")]

waterfall :: Location
waterfall = Location "waterfall" []
    [(East,"road"), (South,"river")]

riverLoc :: Location
riverLoc = Location "river" []
    [(North,"waterfall"), (East,"rocky_road"), (South,"shelter")]

wheatField :: Location
wheatField = Location "wheat_field" [hay]
    [(West,"cabbage_field"), (East,"lake"), (South,"barn")]

cabbageField :: Location
cabbageField = Location "cabbage_field" []
    [(East,"wheat_field"), (West,"bridge"), (South,"car")]

bridge :: Location
bridge = Location "bridge" []
    [(East,"wheat_field"), (West,"town")]

barn :: Location
barn = Location "barn" [catnip, brick]
    [(North,"wheat_field"), (West,"car"), (East,"forest"), (South,"road")]

car :: Location
car = Location "car" [] []

lake :: Location
lake = Location "lake" [] []

graveyard :: Location
graveyard = Location "graveyard" [bone]
    [(East,"town")]

town :: Location
town = Location "town" [dog, rat]
    [(East,"bridge"), (West,"graveyard"), (South,"home")]

home :: Location
home = Location "home" []
    []

allLocationsMap :: M.Map String Location
allLocationsMap = M.fromList
    [
        (name startCage, startCage),
        (name forest, forest),
        (name lowForest, lowForest),
        (name infiniteForest, infiniteForest),
        (name road, road),
        (name rockyRoad, rockyRoad),
        (name meadow, meadow),
        (name waterfall, waterfall),
        (name riverLoc, riverLoc),
        (name wheatField, wheatField),
        (name cabbageField, cabbageField),
        (name bridge, bridge),
        (name barn, barn),
        (name graveyard, graveyard),
        (name town, town),
        (name home, home),
        (name car, car),
        (name lake, lake)
    ]
