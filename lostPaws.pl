/* lostPaws - interactive fiction */

:- dynamic i_am_at/1, at/2, holding/1, hidden/2, hunger/1.
:- dynamic stairs_built/0, scarecrow_built/0, eagle_distracted/0, dog_distracted/0.
:- dynamic shelter_clue_found/0, stone_order/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)).


/* START LOCATION */

i_am_at(start_cage).
hunger(0).

inventory_count(N) :-
        findall(X, holding(X), L),
        length(L, N).

/*randomize stones at the beggining of the game*/
init_stones :-
        retractall(shelter_clue_found),
        retractall(stone_order(_)),
        random_permutation([s,h,e,l,t,e,r], Order),
        assert(stone_order(Order)).

/* MAP */

path(start_cage, n, forest).
path(start_cage, w, road).
path(start_cage, e, low_forest).
path(start_cage, s, meadow).

path(forest, n, lake).
path(forest, w, barn).
path(forest, e, infinite_forest).
path(forest, s, start_cage).

path(low_forest, n, infinite_forest).
path(low_forest, w, start_cage).
path(low_forest, e, infinite_forest).

path(infinite_forest, n, infinite_forest).
path(infinite_forest, s, infinite_forest).
path(infinite_forest, e, infinite_forest).
path(infinite_forest, w, infinite_forest).

path(road, n, barn).
path(road, e, start_cage).
path(road, w, waterfall).
path(road, s, rocky_road).

path(rocky_road, n, road).
path(rocky_road, w, river).
path(rocky_road, e, meadow).
path(rocky_road, s, shelter).

path(meadow, n, start_cage).
path(meadow, w, rocky_road).
path(meadow, e, infinite_forest).
path(meadow, s, shelter).

path(waterfall, e, road).
path(waterfall, s, river).

path(river, n, waterfall).
path(river, e, rocky_road).
path(river, s, shelter).

path(wheat_field, w, cabbage_field).
path(wheat_field, e, lake).
path(wheat_field, s, barn).

path(cabbage_field, e, wheat_field).
path(cabbage_field, w, bridge).
path(cabbage_field, s, car).

path(bridge, e, wheat_field).
path(bridge, w, town).

path(barn, n, wheat_field).
path(barn, w, car).
path(barn, e, forest).
path(barn, s, road).

path(graveyard, e, town).

path(town, e, bridge).
path(town, w, graveyard).
path(town, s, home).


/*HUNGER*/
max_hunger(12).

increase_hunger :-
        hunger(H),
        H1 is H + 1,
        retract(hunger(H)),
        assert(hunger(H1)),
        check_hunger.

check_hunger :-
        hunger(H),
        max_hunger(Max),
        H >= Max,
        i_am_at(home),
        !, check_win.

check_hunger :-
        hunger(H),
        max_hunger(Max),
        H >= Max,
        write('Muffin collapses from exhaustion...'), nl,
        lose, !.

check_hunger.

/* OBJECTS */

at(catnip, barn).
at(brick, barn).
at(cardboard_box, forest).
at(cage, start_cage).
at(broken_stool, road).
at(branch, low_forest).
at(chocolate, road).
at(dog, town).
at(rat, town).
at(river, river).
at(white_rock, meadow).
at(hay, wheat_field).
at(big_stick, forest).
at(small_stick, low_forest).
at(bone, graveyard).
at(shell, nowhere).
at(pipe, nowhere).
at(sofa, road).

/* HIDDEN */
hidden(cod, cardboard_box).
hidden(mackerel, cardboard_box).
hidden(roach, cardboard_box).
hidden(herring, pipe).
hidden(cool_pebble, river).
hidden(hat, white_rock).
hidden(brown_mouse, hay).
hidden(tiny_mouse, brick).
hidden(hamster, cage).
hidden(gerbil, hat).
hidden(squirrel, branch).

/* TAKE OBJECT */
take(dog) :-
        write('The dog is far too big and angry for Muffin to pick up.'), nl,
        !.

take(river) :-
        write('The river is way too big for Muffin to pick up.'), nl,
        !.

take(sofa) :-
        write('The sofa is too heavy for Muffin to move.'), nl,
        !.

take(X) :-
        inventory_count(N),
        N >= 3,
        write('Muffin tries to pick up the '), write(X), write('.'), nl,
        write('But her tiny cat mouth is already full.'), nl,
        !.

take(X) :-
        holding(X),
        write('You already have it!'), nl, !.

take(white_rock) :-
        i_am_at(meadow),
        write('You pick up the white_rock.'), nl,
        hidden(hat, white_rock),
        retract(hidden(hat, white_rock)),
        assert(at(hat, meadow)),
        retract(at(white_rock, meadow)),
        assert(holding(white_rock)),
        write('Something was underneath... a hat!'), nl,
        !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('You pick up the '), write(X), write('.'), nl, !.

take(_) :-
        write('You do not see that here.'), nl.

/* DROP OBJECT */
drop(bone) :-
        i_am_at(town),
        at(dog, town),
        holding(bone),
        retract(holding(bone)),
        assert(dog_distracted),
        write('The dog grabs the bone and runs away happily!'), nl,
        !.

drop(X) :-
        i_am_at(town),
        (X = cod ; X = mackerel ; X = herring ; X = roach),
        holding(X),
        retract(holding(X)),
        assert(eagle_distracted),
        write('An eagle swoops down and grabs the fish!'), nl,
        write('It flies away with its meal.'), nl,
        !.

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('Dropped.'), nl, !.


drop(_) :-
        write('You are not holding it.'), nl.

/* SEARCH */
search(river) :-
        i_am_at(river),
        hidden(cool_pebble, river),
        retract(hidden(cool_pebble, river)),
        assert(at(cool_pebble, river)),
        write('Muffin splashes the water with her paw.'), nl,
        write('She finds a shiny cool_pebble!'), nl, !.

search(Object) :-
        i_am_at(Place),
        at(Object, Place),
        hidden(Item, Object),
        retract(hidden(Item, Object)),
        assert(at(Item, Place)),
        write('Muffin searches the '), write(Object),
        write(' and finds a '), write(Item), write('!'), nl, !.

search(Object) :-
        i_am_at(Place),
        at(Object, Place),
        write('Nothing else inside.'), nl, !.

search(_) :-
        write('You find nothing here.'), nl.

/*EAT*/
eat(catnip) :-
        holding(catnip),
        retract(holding(catnip)),
        write('Muffin eats the catnip.'), nl,
        write('Everything spins...'), nl,
        write('She runs around the barn knocking things over.'), nl,
        write('The barn owner hears the noise and thinks there is an intruder.'), nl,
        write('BANG!'), nl,
        write('Muffin has been shot.'), nl,
        lose, !.

eat(chocolate) :-
        holding(chocolate),
        retract(holding(chocolate)),
        write('Muffin eats the chocolate...'), nl,
        write('But chocolate is poisonous for cats!'), nl,
        write('She feels very sick...'), nl,
        lose, !.

eat(X) :-
        holding(X),
        (X = cod; X = mackerel; X = herring; X = roach),
        retract(holding(X)),
        hunger(H),
        H1 is max(0, H - 3),
        retract(hunger(H)),
        assert(hunger(H1)),
        max_hunger(Max),
        write('Muffin happily eats the fish.'), nl,
        write('She feels a bit less tired. (hunger: '), write(H1), write(' /'), write(Max), write(')'), nl,
        !.

eat(X) :-
        holding(X),
        (X = tiny_mouse ; X = brown_mouse; X = hamster; X = gerbil; X = rat; X = squirrel),
        retract(holding(X)),
        hunger(H),
        H1 is max(0, H - 2),
        retract(hunger(H)),
        assert(hunger(H1)),
        max_hunger(Max),
        write('Muffin happily eats the rodent.'), nl,
        write('She feels a bit less tired. (hunger: '), write(H1), write(' /'), write(Max), write(')'), nl,
        !.

eat(_) :-
        write('You cannot eat that.'), nl.

/*ATTACH*/
/*build scarecrow*/
build_step(big_stick, hay, frame).
build_step(small_stick, frame, headless_man).
build_step(hat, headless_man, scarecrow).

/*build stairs*/
build_step(pipe, broken_stool, stool).
build_step(cardboard_box, cage, tower).
build_step(stool, tower, stairs).

attach(Item, Base) :-
        build_step(Item, Base, Result),
        check_attach(Item, Base),
        perform_attach(Item, Base, Result), !.

attach(_, _) :-
        write('Those things cannot be attached together.'), nl.

/*CHECK ATTACH*/
check_attach(Item, _) :-
        \+ holding(Item),
        write('You do not have that item.'), nl,
        !, fail.

check_attach(_, Base) :-
        i_am_at(Place),
        \+ at(Base, Place),
        write('The second item is not here.'), nl,
        !, fail.


check_attach(big_stick, hay) :-
        \+ at(hay, wheat_field),
        write('You need to build the scarecrow in the wheat field.'), nl,
        !, fail.

check_attach(small_stick, frame) :-
        \+ at(frame, wheat_field),
        write('You need to build the scarecrow in the wheat field.'), nl,
        !, fail.

check_attach(hat, headless_man) :-
        \+ at(headless_man, wheat_field),
        write('You need to build the scarecrow in the wheat field.'), nl,
        !, fail.

check_attach(cardboard_box, cage) :-
        \+ i_am_at(bridge),
        write('You need to build the tower near the bridge.'), nl,
        !, fail.

check_attach(stool, tower) :-
        \+ i_am_at(bridge),
        write('You need to build the stairs near the bridge.'), nl,
        !, fail.

check_attach(_, _).

perform_attach(Item, Base, Result) :-
        retract(holding(Item)),
        i_am_at(Place),
        retract(at(Base, Place)),
        assert(at(Result, Place)),
        describe_build(Result).

describe_build(frame) :-
        write('You attach a stick into the hay bundle. It is a frame.'), nl.

describe_build(headless_man) :-
        write('The scarecrow now has two arms, making a headless_man'), nl.

describe_build(scarecrow) :-
        retract(at(scarecrow, wheat_field)),
        assert(scarecrow_built),
        write('You place the hat on top.'), nl,
        write('A scary scarecrow stands between the fields!'), nl,
        write('The crows fly away.'), nl.

describe_build(stool) :-
        write('You fix the broken stool using the pipe.'), nl.

describe_build(tower) :-
        write('You place the cardboard box on top of the cage.'), nl,
        write('It forms a small tower.'), nl.

describe_build(stairs) :-
        write('You add the stool to the tower.'), nl,
        write('Now Muffin can climb it like stairs!'), nl,
        assert(stairs_built).

/*ARRANGE*/
arrange(L1,L2,L3,L4,L5,L6,L7) :-
    i_am_at(rocky_road),
    Attempt = [L1,L2,L3,L4,L5,L6,L7],
    check_stones(Attempt).

arrange(b,w,c,s) :-
        i_am_at(waterfall),
        at(brick, waterfall),
        at(white_rock, waterfall),
        at(cool_pebble, waterfall),
        at(shell, waterfall),
        build_totem, !.

arrange(_) :-
        i_am_at(waterfall),
        write('You do not have all the stones needed to build the totem.'), nl,
        !.

/*CHECK STONES*/
check_stones([s,h,e,l,t,e,r]) :-
        \+ shelter_clue_found,
        assert(shelter_clue_found),
        retract(at(shell, nowhere)),
        assert(at(shell, rocky_road)),
        write('The stones glow faintly...'), nl,
        write('SHELTER.'), nl,
        write('Muffin suddenly understands!'), nl,
        write('The animal shelter must be south of here!'), nl,
        write("I don't want to live in a cage!"), nl,
        write('Something shiny appears between the stones... a shell!'), nl,
        !.

check_stones([s,h,e,l,t,e,r]) :-
        shelter_clue_found,
        write('You already solved this puzzle.'), nl,
        !.

check_stones(_) :-
        write('The stones do not seem to form a meaningful word.'), nl.

/*BUILD TOTEM*/
build_totem :-
        write('Muffin carefully stacks the stones into a small totem.'), nl,
        write('Brick at the bottom, then white rock, cool pebble and shell.'), nl,
        write('The rushing waterfall sounds pleasant and she feels safe with the totem around.'), nl,
        write('Muffin curls up beside the totem and rests.'), nl,
        spawn_pipe.

spawn_pipe :-
        \+ at(pipe, waterfall),
        assert(at(pipe, waterfall)),
        write('Something floats toward the shore...'), nl,
        write('A metal pipe washes up from the water!'), nl,
        write('Next to it, something is moving too.'), nl.

/* MOVEMENT SHORTCUTS */

n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).

/* MOVEMENT */

go(Direction) :-
        i_am_at(town),
        Direction = s,
        \+ dog_distracted,
        write('A big dog blocks your way to the south and growls.'), nl,
        write('Maybe you could give him something to eat...'), nl, !.

go(Direction) :-
        i_am_at(town),
        Direction = s,
        \+ eagle_distracted,
        write('As Muffin walks forward...'), nl,
        write('A huge eagle swoops down from above!'), nl,
        write('Its talons grab Muffin before she can react.'), nl,
        write('The ground fades away...'), nl,
        lose, !.

go(n) :-
        (i_am_at(wheat_field); i_am_at(cabbage_field); i_am_at(town)),
        write('There is a highway up ahead.'), nl,
        write('Muffin is too scared to go this way.'), nl, !.

go(w) :-
        i_am_at(wheat_field),
        \+ scarecrow_built,
        write('As Muffin enters the cabbage field...'), nl,
        write('A flock of angry crows attacks!'), nl,
        write('CAW! CAW!'), nl,
        write('They chase Muffin back to the wheat field.'), nl,
        !.

go(w) :-
        i_am_at(wheat_field),
        scarecrow_built,
        retract(i_am_at(wheat_field)),
        assert(i_am_at(cabbage_field)),
        increase_hunger,
        look, !.

go(w) :-
        i_am_at(bridge),
        \+ stairs_built,
        write('A tall stone gate, flanked by two castle towers, blocks the entrance to the town.'), nl,
        write('Muffin could jump over... if she was taller.'), nl,
        write('Maybe she could build something to climb on.'), nl,
        !.

go(w) :-
        i_am_at(bridge),
        stairs_built,
        retract(i_am_at(bridge)),
        assert(i_am_at(town)),
        write('Muffin climbs the tower of objects...'), nl,
        write('She hops over the stone gate!'), nl,
        increase_hunger,
        look, !.

go(Direction) :-
        i_am_at(river),
        (Direction = w),
        write('Muffin tries to step into the river.'), nl,
        write('The current pulls her away!'), nl,
        write('She cannot swim...'), nl,
        write('Muffin drowns.'), nl,
        lose, !.

go(Direction) :-
        i_am_at(waterfall),
        (Direction = n ; Direction = w),
        write('Muffin tries to step into the water.'), nl,
        write('The current pulls her away!'), nl,
        write('She cannot swim...'), nl,
        write('Muffin drowns.'), nl,
        lose, !.

go(Direction) :-
        i_am_at(graveyard),
        (Direction = n ; Direction = w; Direction = s),
        write('The graveyard is surrounded by tall stone walls.'), nl,
        write('There is no exit that way.'), nl,
        !.

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        check_car,
        check_lake,
        check_win,
        increase_hunger,
        !, look.

go(_) :-
        write('Muffin cannot go that way.'), nl.

/*CHECK CAR*/
check_car :-
        i_am_at(car),
        write('Muffin sneaks behind the barn into a parking lot.'), nl,
        write('Suddenly a car starts moving!'), nl,
        write('She is disoriented and runs directly under the wheels...'), nl,
        write('CRUNCH.'), nl,
        lose, !.

check_car.

/*CHECK LAKE*/
check_lake :-
        i_am_at(lake),
        write('Muffin visits the lake.'), nl,
        write('But the ground is slippery here!'), nl,
        write("She falls into the water. Muffin can't swim and drowns."), nl,
        lose, !.

check_lake.

/* LOOK */
look :-
        i_am_at(Place),
        hunger(T),
        max_hunger(Max),
        write('[hunger: '), write(T), write(' /'), write(Max), write(')'), nl,
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.

/* SHOW INVENTORY */

show_mouth :-
        write('Muffin is carrying:'), nl,
        holding(X),
        write('- '), write(X), nl,
        fail.

show_mouth :-
        \+ holding(_),
        write('Nothing. Her mouth is empty.'), nl, !.

show_mouth :-
        write('That is everything in her mouth.'), nl.

/* OBJECTS AROUND */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* WIN CONDITION */

check_win :-
        i_am_at(home),
        write('Muffin recognizes the smell of her house!'), nl,
        write('She waddles inside and jumps onto the sofa.'), nl,
        write('Home at last.'), nl,
        write('YOU WIN!'), nl,
        finish, !.

check_win.

/*LOSE*/
lose :-
        nl,
        write('YOU LOSE.'), nl,
        finish, !, fail.

/* GAME END */

finish :-
        nl,
        write('---- The game is over. To exit type: halt.'),
        nl,
        nl.

/* INSTRUCTIONS */
title :-
    write('============================================================'), nl,
    write('  _                 _  _____                         '), nl,
    write(' | |               | | |  __ \\                        '), nl,
    write(' | |      ___  ___ | |_| |__) |__ __      __ ___     '), nl,
    write(' | |     / _ \\/ __|| __|  ___/ _ `\\ \\ /\\ / // __|    '), nl,
    write(' | |____| (_) \\__ \\| |_| |  | (_| |\\ V  V / \\__ \\    '), nl,
    write(' |______|\\___/|___/ \\__|_|   \\__,_| \\_/\\_/  |___/    '), nl,
    write('============================================================'), nl,
    write('         THE JOURNEY BEGINS - find your way home           '), nl,
    write('============================================================'), nl,
    write('                       |\\__/,|   (`\\'),nl,
    write('                     _.|o o  |_   ) )'),nl,
    write('                   -(((---(((--------'),nl,
    write('        [to start the game write: start.]'),nl,
    write('============================================================'), nl.



instructions :-
        nl,
        write('============================================================'), nl,
        write('You are Muffin, a fat and very lazy house cat.'), nl,
        write('You were lying in the warm sun, happily baking like a loaf of bread.'), nl,
        nl,
        write('Suddenly, someone picked you up.
Before you could complain, you were placed inside a metal cage and loaded into the back of a truck. Around you were many other cages filled with nervous animals.'), nl,
        write('After many long hours, the truck turned onto a rough, bumpy road. The cages rattled and slid across the floor.'), nl,
        write('Then — **BANG!**'), nl,
        write("The truck's back door swung open and yours cage rolled out of the truck and into the tall start_cage by the road."), nl,
        write('The truck disappeared into the distance at the south.'), nl,
        write('You open the bend cage door and step outside'), nl,
        write('You are free, but can you find your way home?'), nl,
        nl,
        write('==== QUEST: Return back home'), nl,
        nl,
        write('---- Commands:'), nl,
        write('start.           -- start game'), nl,
        write('n. s. e. w.      -- move'), nl,
        write('take(item).    -- pick up item'), nl,
        write('drop(item).    -- drop item'), nl,
        write('search(object).  -- search container'), nl,
        write('eat(item).       -- eat something'), nl,
        write('attach(a,b).     -- attach object a to object b'), nl,
        write('arrange(a,b,c,...).     -- arrange objects a, b, c, ... in order'), nl,
        write('look.            -- look around'), nl,
        write('show_mouth.      -- show everything Muffin is carring in her mouth'), nl,
        write('instructions.    -- help'), nl,
        write('halt.            -- quit'), nl,
        write('============================================================'), nl,
        nl.

/* START GAME */

start :-
        init_stones,
        title,
        instructions,
        look.

/* DESCRIPTIONS */

describe(start_cage) :-
        write('       ___      '), nl,
        write('      |[_]|_  "  '), nl,
        write('  vvVvVvVvVvVvv'), nl,
        write('Tall grass waves around you.'), nl,
        write('Your metal cage lies behind you.'), nl.

describe(forest) :-
        write('      /\\        /\\      '), nl,
        write('     /  \\      /  \\     '), nl,
        write('    /____\\    /____\\    '), nl,
        write('  /\\  ||   /\\   ||  /\\  '), nl,
        write(' /__\\ ||  /__\\  || /__\\ '), nl,
        write('  ||  ||   ||   ||  ||  '), nl,
        write('A shady forest. Birds chirp in the trees.'), nl,
        write('It smells like adventure... and maybe snacks.'), nl.

describe(low_forest) :-
        write('  /\\                  '), nl,
        write(' /__\\      /\\         '), nl,
        write('  ||       /__\\        '), nl,
        write('vvVvVvv   vv||vvVvVvv     '), nl,
        write('The forest here is thinner.'), nl,
        write('You can still see the tall grass where the cage fell.'), nl.

describe(infinite_forest) :-
        write('  /\\  /\\  /\\  /\\  /\\'), nl,
        write(' /__\\/__\\/__\\/__\\/__\\ '), nl,
        write('  ||  ||  ||  ||  ||  '), nl,
        write('Trees stretch endlessly in every direction.'), nl,
        write('The forest looks exactly the same everywhere.'), nl,
        write('Muffin is completely lost.'), nl.

describe(road) :-
        write('   __________   '), nl,
        write('               '), nl,
        write(' ===  ===  === '), nl,
        write('             '), nl,
        write('A dusty road where the truck drove away.'), nl,
        write('You see tire tracks leading north.'), nl,
        write('Some trash is laying on the side of the road.'), nl.

describe(rocky_road) :-
        write('  __________   '), nl,
        write(' .o .  o .  o   '), nl,
        write(' ===  ===  === '), nl,
        write(' o .  .  o . .  '), nl,
        write('A rough rocky road full of stones.'), nl,
        write('Seven carved stones lie on the ground.'), nl,
        write('Letters on them read: '),
        stone_order(L),
        write(L), nl,
        write('Maybe they form a word...'), nl.

describe(meadow) :-
        write('    _     _     _      '), nl,
        write('   ( )   ( )   ( )   __ '), nl,
        write('    |     |     |   (  )'), nl,
        write('   \\|/   \\|/   \\|/  (__)'), nl,
        write('A quiet meadow full of pretty flowers.'), nl,
        write('Something shiny lies under a white_rock.'), nl.

describe(car) :-
        write('      _______      '), nl,
        write('    _/_|     \\_    '), nl,
        write('   |_|_______|_|   '), nl,
        write(' ----(o)---(o)----  '), nl,
        write('A parked farm car stands behind the barn.'), nl,
        write('The engine suddenly rumbles to life...'), nl.

describe(river) :-
        write('  ~ ~ ~ ~ ~ ~ ~ ~  '), nl,
        write('   <><    <><      '), nl,
        write('   ~ ~ ~ ~ ~ ~ ~   '), nl,
        write('  ~ ~ ~ ~ ~ ~ ~ ~  '), nl,
        write('A fast flowing river blocks your path to the west.'), nl,
        write('You can see fish swimming in the water.'), nl,
        write('The current looks very strong.'), nl.

describe(waterfall) :-
        write('     | | | |       '), nl,
        write('     | | | |       '), nl,
        write('     | | | |       '), nl,
        write('  _~~_~~_~~_~~_    '), nl,
        write(' (_____________)   '), nl,
        write('A beutifull waterfall blocks your path to the west-north.'), nl,
        write('This might be a peaceful place to arrange something and rest in its shade.'), nl,
        write('The smooth stones by the water look perfect for stacking.'), nl,
        write('Muffin notices that some are large and heavy, while others are small and light.'), nl,
        write('Three stones and a shell together could make a small totem if placed carefully.'), nl,
        write('Perhaps they should stand from the strongest base to the lightest top.'), nl,
        write('If only she could remember the first sounds of their names...'), nl.

describe(barn) :-
        write('      _______      '), nl,
        write('     / _____ \\     '), nl,
        write('    / /|_|_|\\ \\    '), nl,
        write('    |_|  _  |_|    '), nl,
        write('vVvV|_| | | |_|vVvVv '), nl,
        write('An old wooden barn. It smells like mice.'), nl,
        write('Sadly, they are all hiding.'), nl.

describe(town) :-
        write('  |  |_______|  |  '), nl,
        write('  |   _     _   |  '), nl,
        write('  |  |_| ^ |_|  |  '), nl,
        write('  |     |V|     |  '), nl,
        write('  |    / m \\    |  '), nl,
        write('You arrive at a small town street.'), nl,
        write('A big dog sits at the south of the road and barks at you. He doesnt like cats, esspecialy ones that look a bit familiar.'), nl.

describe(wheat_field) :-
        write('   \\/  \\/  \\/  \\/  '), nl,
        write('   \\/  \\/  \\/  \\/  '), nl,
        write('  _|   |  _|   |   '), nl,
        write(' (_)     (_)           '), nl,
        write('A huge wheat field sways in the wind.'), nl,
        write('You see a bundle of hay here.'), nl,
        write('To the west lies a cabbage field.'), nl.

describe(cabbage_field) :-
        write('  \\(w)/  \\(w)/  \\(w)/ '), nl,
        write('   ""     ""     ""   '), nl,
        write('\\(w)/  \\(w)/  \\(w)/ '), nl,
        write(' ""     ""     ""   '), nl,
        write('Rows of cabbage stretch across the field.'), nl,
        write('Crows sit everywhere watching suspiciously.'), nl.

describe(bridge) :-
        write('   __________      '), nl,
        write('  |__________|     '), nl,
        write('  | |      | |     '), nl,
        write('  | |  ~~  | |     '), nl,
        write('     ~~~~ ~~     '), nl,
        write('A wooden bridge crosses a small stream.'), nl,
        write('The town is just beyond it.'), nl.

describe(graveyard) :-
        write('  _|_   ___   _|_  '), nl,
        write(' |   | | o | |   | '), nl,
        write(' |___| |___| |___| '), nl,
        write(' , ` , ` , ` , ` , '), nl,
        write('An old graveyard full of crooked tombstones.'), nl,
        write('Cold wind rustles the dead leaves.'), nl,
        write('Tall stone walls surround the graveyard on all sides.'), nl,
        write('The only exit is back east toward the town.'), nl.

describe(home) :-
        write('          ( (        '), nl,
        write('           ) )        '), nl,
        write('      ____|_|____     '), nl,
        write('     /-  -  -  - \\    '), nl,
        write('    /__-___-__-__-\\   '), nl,
        write('   |   _  _   _    |  '), nl,
        write('   |  |_||_| | |   |  '), nl,
        write(' __|_________|_|___|__'), nl,
        write('  vvVvVVvVvvvVvvVvVvv '), nl,
        write('Your house!'), nl,
        write('The warm sofa awaits.'), nl.

describe(shelter) :-
        write('   _________       '), nl,
        write('  |_|_|_|_|_|      '), nl,
        write('  |_|_|_|_|_|      '), nl,
        write('  |_|_|_|_|_|      '), nl,
        write('You find an animal shelter.'), nl,
        write('Some people grab you and put in a cage.'), nl,
        write('Muffin curls up and is very sad.'), nl,
        write('You will never find your way back home.'), nl,
        lose.