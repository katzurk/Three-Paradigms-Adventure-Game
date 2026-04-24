module Descriptions where
import World
import qualified Data.Map as M

titleText = [
    "============================================================",
    "  _                 _  _____                         ",
    " | |               | | |  __ \\                        ",
    " | |      ___  ___ | |_| |__) |__ __      __ ___     ",
    " | |     / _ \\/ __|| __|  ___/ _ `\\ \\ /\\ / // __|    ",
    " | |____| (_) \\__ \\| |_| |  | (_| |\\ V  V / \\__ \\    ",
    " |______|\\___/|___/ \\__|_|   \\__,_| \\_/\\_/  |___/    ",
    "============================================================",
    "         THE JOURNEY BEGINS - find your way home          ",
    "============================================================",
    "                       |\\__/,|   (`\\",
    "                     _.|o o  |_   ) )",
    "                   -(((---(((--------",
    "============================================================",
    ""
    ]

introductionText = [
    "============================================================",
    "You are Muffin, a fat and very lazy house cat.",
    "You were lying in the warm sun, happily baking like a loaf of bread.",
    "",
    "Suddenly, someone picked you up.",
    "Before you could even complain, you were placed inside a metal cage and loaded into the back of a truck. Around you were many other cages filled with nervous animals.",
    "After many long hours, the truck turned onto a rough, bumpy road. The cages rattled and slid across the floor.",
    "Then — **BANG!**",
    "The truck's back door swung open and your cage rolled out of the truck and into the tall start_cage by the road.",
    "The truck disappeared into the distance to the south.",
    "You open the bend cage door and step outside",
    "You are free, but can you find your way home?",
    "",
    "==== QUEST: Return back home",
    ""
    ]

instructionsText = [
    "---- Commands:",
    "move [n, s, e, w]    -- move",
    "take item            -- pick up item",
    "drop item            -- drop item",
    "search object        -- search container",
    "eat item             -- eat something",
    "attach a b           -- attach object a to object b",
    "arrange a b c ...    -- arrange objects a, b, c, ... in order",
    "look                 -- look around",
    "show mouth           -- show everything Muffin is carring in her mouth",
    "instructions         -- to see these instructions.",
    "quit                 -- to end the game and quit.",
    ""
    ]

type LocationDescriptions = M.Map String [String]
locDescriptions :: LocationDescriptions
locDescriptions = M.fromList
    [ ("start_cage",
        [ "       ___      "
        , "      |[_]|_  \"  "
        , "  vvVvVvVvVvVvv"
        , "Tall grass waves around you."
        , "Your metal cage lies behind you."
        ])
    , ("forest",
        [ "      /\\        /\\      "
        , "     /  \\      /  \\     "
        , "    /____\\    /____\\    "
        , "  /\\  ||   /\\   ||  /\\  "
        , " /__\\ ||  /__\\  || /__\\ "
        , "  ||  ||   ||   ||  ||  "
        , "A shady forest. Birds chirp in the trees."
        , "It smells like adventure... and maybe snacks."
        ])
    , ("low_forest",
        [ "  /\\                  "
        , " /__\\       /\\         "
        , "  ||       /__\\        "
        , "vvVvVvv   vv||vvVvVvv     "
        , "The forest here is thinner."
        , "You can still see the tall grass where the cage fell."
        ])
    , ("infinite_forest",
        [ "  /\\  /\\  /\\  /\\  /\\"
        , " /__\\/__\\/__\\/__\\/__\\ "
        , "  ||  ||  ||  ||  ||  "
        , "Trees stretch endlessly in every direction."
        , "The forest looks exactly the same everywhere."
        , "Muffin is completely lost."
        ])
    , ("road",
        [ "   __________   "
        , "               "
        , " ===  ===  === "
        , "             "
        , "A dusty road where the truck drove away."
        , "You see tire tracks leading north."
        , "Some trash is laying on the side of the road."
        ])
    , ("rocky_road",
        [ "  __________   "
        , " .o .  o .  o   "
        , " ===  ===  === "
        , " o .  .  o . .  "
        , "A rough rocky road full of stones."
        , "Seven carved stones lie on the ground."
        , "Letters on them read: h, l, e, t, s, r, e"
        , "Maybe they can form a word..."
        ])
    , ("meadow",
        [ "    _     _     _      "
        , "   ( )   ( )   ( )   __ "
        , "    |     |     |   (  )"
        , "   \\|/   \\|/   \\|/  (__)"
        , "A quiet meadow full of pretty flowers."
        , "Something shiny lies under a white_rock."
        ])
    , ("car",
        [ "      _______      "
        , "    _/_|     \\_    "
        , "   |_|_______|_|   "
        , " ----(o)---(o)----  "
        , "A parked farm car stands behind the barn."
        , "The engine suddenly rumbles to life..."
        ])
    , ("river",
        [ "  ~ ~ ~ ~ ~ ~ ~ ~  "
        , "   <><    <><      "
        , "   ~ ~ ~ ~ ~ ~ ~   "
        , "  ~ ~ ~ ~ ~ ~ ~ ~  "
        , "A fast flowing river blocks your path to the west."
        , "You can see fish swimming in the water."
        , "The current looks very strong."
        ])
    , ("waterfall",
        [ "     | | | |       "
        , "     | | | |       "
        , "     | | | |       "
        , "  _~~_~~_~~_~~_    "
        , " (_____________)   "
        , "A beautiful waterfall blocks your path to the west-north."
        , "This might be a peaceful place to arrange something and rest in its shade."
        , "The smooth stones by the water look perfect for stacking."
        , "Muffin notices that some are large and heavy, while others are small and light."
        , "Three stones and a shell together could make a small totem if placed carefully."
        , "Perhaps they should stand from the strongest base to the lightest top."
        , "If only she could remember the first sounds of their names..."
        ])
    , ("barn",
        [ "      _______      "
        , "     / _____ \\     "
        , "    / /|_|_|\\ \\    "
        , "    |_|  _  |_|    "
        , "vVvV|_| | | |_|vVvVv "
        , "An old wooden barn. It smells like mice."
        , "Sadly, they are all hiding."
        ])
    , ("town",
        [ "  |  |_______|  |  "
        , "  |   _     _   |  "
        , "  |  |_| ^ |_|  |  "
        , "  |     |V|     |  "
        , "  |    / m \\    |  "
        , "You arrive at a small town street."
        , "A big dog sits at the south of the road and barks at you. He doesn't like cats, especially ones that look a bit familiar."
        ])
    , ("wheat_field",
        [ "   \\/  \\/  \\/  \\/  "
        , "   \\/  \\/  \\/  \\/  "
        , "  _|   |  _|   |   "
        , " (_)     (_)           "
        , "A huge wheat field sways in the wind."
        , "You see a bundle of hay here."
        , "To the west lies a cabbage field."
        ])
    , ("cabbage_field",
        [ "  \\(w)/  \\(w)/  \\(w)/ "
        , "   \"\"     \"\"     \"\"   "
        , "\\(w)/  \\(w)/  \\(w)/ "
        , " \"\"     \"\"     \"\"   "
        , "Rows of cabbage stretch across the field."
        , "Crows sit everywhere watching suspiciously."
        ])
    , ("bridge",
        [ "   __________      "
        , "  |__________|     "
        , "  | |      | |     "
        , "  | |  ~~  | |     "
        , "     ~~~~ ~~     "
        , "A wooden bridge crosses a small stream."
        , "The town is just beyond it."
        ])
    , ("graveyard",
        [ "  _|_   ___   _|_  "
        , " |   | | o | |   | "
        , " |___| |___| |___| "
        , " , ` , ` , ` , ` , "
        , "An old graveyard full of crooked tombstones."
        , "Cold wind rustles the dead leaves."
        , "Tall stone walls surround the graveyard on all sides."
        , "The only exit is back east towards the town."
        ])
    , ("home",
        [ "          ( (        "
        , "           ) )        "
        , "      ____|_|____     "
        , "     /-  -  -  - \\    "
        , "    /__-___-__-__-\\   "
        , "   |   _  _   _    |  "
        , "   |  |_||_| | |   |  "
        , " __|_________|_|___|__"
        , "  vvVvVVvVvvvVvvVvVvv "
        , "Your house!"
        , "The warm sofa awaits."
        ])
    ]

type ConditionMessages = M.Map String [String]
conditionMessages :: ConditionMessages
conditionMessages = M.fromList
    [ ("dog_blocked",
        [ "A big dog blocks your way to the south and growls."
        , "Maybe you could give him something to eat..."
        ])
    , ("eagle_death",
        [ "As Muffin walks forward..."
        , "A huge eagle swoops down from above!"
        , "Its talons grab Muffin before she can react."
        , "The ground fades away..."
        ])
    , ("crows_blocked",
        [ "As Muffin enters the cabbage field..."
        , "A flock of angry crows attacks!"
        , "CAW! CAW!"
        , "They chase Muffin back to the wheat field."
        ])
    , ("gate_blocked",
        [ "A tall stone gate, flanked by two castle towers, blocks the entrance to the town."
        , "Muffin could jump over... if she was taller."
        , "Maybe she could build something to climb on."
        ])
    , ("gate_unlocked",
        [ "Muffin climbs the tower of objects..."
        , "She hops over the stone gate!"
        ])
    , ("waterfall_death",
        [ "Muffin tries to step into the water."
        , "The current pulls her away!"
        , "She cannot swim..."
        , "Muffin drowns."
        ])
    , ("river_death",
        [ "Muffin tries to step into the river."
        , "The current pulls her away!"
        , "She cannot swim..."
        , "Muffin drowns."
        ])
    , ("car_death",
        [ "Muffin sneaks behind the barn into a parking lot."
        , "Suddenly a car starts moving!"
        , "She is disoriented and runs directly under the wheels..."
        , "CRUNCH."
        ])
    , ("lake_death",
        [ "Muffin visits the lake."
        , "But the ground is slippery here!"
        , "She falls into the water. Muffin can't swim and drowns."
        ])
    , ("shelter_gameover",
        [ "   _________       "
        , "  |_|_|_|_|_|      "
        , "  |_|_|_|_|_|      "
        , "  |_|_|_|_|_|      "
        , "You find an animal shelter."
        , "Some people grab you and put in a cage."
        , "Muffin curls up and is very sad."
        , "You will never find your way back home."
        ])
    ]

eatDescriptions :: M.Map String [String]
eatDescriptions = M.fromList
    [ ("catnip",
        [ "Muffin eats the catnip.",
          "Everything spins...",
          "She runs around the barn knocking things over.",
          "The barn owner hears the noise and thinks there is an intruder.",
          "BANG!",
          "Muffin has been shot."
        ])
    , ("chocolate",
        [ "Muffin eats the chocolate...",
          "But chocolate is poisonous for cats!",
          "She feels very sick..."
        ])
    , ("fish", ["Muffin happily eats the fish."])
    , ("rodent", ["Muffin happily eats the rodent."])
    , ("default", ["You cannot eat that."])
    ]

buildRecipes :: [(String, String, String, String)]
buildRecipes =
    [ ("big_stick",    "hay",          "frame",        "wheat_field")
    , ("small_stick",  "frame",        "headless_man", "wheat_field")
    , ("hat",          "headless_man", "scarecrow",    "wheat_field")
    , ("cardboard_box","cage",         "tower",        "bridge")
    , ("stool",        "tower",        "stairs",       "bridge")
    ]

buildMessages :: M.Map String [String]
buildMessages = M.fromList
    [ ("frame",        ["You attach a stick into the hay bundle.", "It starts to look like a frame."])
    , ("headless_man", ["The scarecrow now has two arms.", "It looks like a headless man!"])
    , ("scarecrow",    ["You place the hat on top.", "A scary scarecrow stands between the fields!", "The crows fly away."])
    , ("tower",        ["You place the cardboard box on top of the cage.", "It forms a small tower."])
    , ("stairs",       ["You add the stool to the tower.", "Now Muffin can climb it like stairs!"])
    ]

type OutOfBoundsMessages = M.Map String [String]
outOfBoundsMessages :: OutOfBoundsMessages
outOfBoundsMessages = M.fromList
    [ ("wheat_field",
        [ "There is a highway up ahead."
        , "Muffin is too scared to go this way."
        ])
    , ("cabbage_field",
        [ "There is a highway up ahead."
        , "Muffin is too scared to go this way."
        ])
    , ("town",
        [ "There is a highway up ahead."
        , "Muffin is too scared to go this way."
        ])
    , ("graveyard",
        [ "The graveyard is surrounded by tall stone walls."
        , "There is no exit that way."
        ])
    ]
