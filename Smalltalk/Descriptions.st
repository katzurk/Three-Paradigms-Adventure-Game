Object subclass: Descriptions [
    Descriptions class >> title [
        ^ '============================================================
    _                 _  _____                         
    | |               | | |  __ \\                        
    | |      ___  ___ | |_| |__) |__ __      __ ___     
    | |     / _ \\/ __|| __|  ___/ _ `\\ \\ /\\ / // __|    
    | |____| (_) \\__ \\| |_| |  | (_| |\\ V  V / \\__ \\    
    |______|\\___/|___/ \\__|_|   \\__,_| \\_/\\_/  |___/    
============================================================
            THE JOURNEY BEGINS - find your way home           
============================================================
                        |\\__/,|   (`\\
                        _.|o o  |_   ) )
                    -(((---(((--------
============================================================

        '.
    ]

    Descriptions class >> instructions     [ 
        ^ '---- Commands:
move [n, s, e, w]    -- move
take item            -- pick up item
drop item            -- drop item  
search object        -- search container
eat item             -- eat something
attach a to b        -- attach object a to object b
arrange a b c ...    -- arrange objects in order
look                 -- look around
show mouth           -- show everything Muffin is carrying
help                 -- see these instructions
quit                 -- end the game
        '.
    ]

    Descriptions class >> introduction [
        ^ '============================================================
You are Muffin, a fat and very lazy house cat.
You were lying in the warm sun, happily baking like a loaf of bread.

Suddenly, someone picked you up.
Before you could even complain, you were placed inside a metal cage.
After many hours, the truck door swung open...
Your cage rolled out into the tall grass by the road.
The truck disappeared. You are free, but can you find your way home?

==== QUEST: Return back home 
        '.
    ]

    Descriptions class >> locations [

        | locations |

        locations := Dictionary new.

        locations at: #startCage put:
        '     ___      
    |[_]|_  "  
vvVvVvVvVvVvv
Tall grass waves around you.
Your metal cage lies behind you.
        '.
        locations at: #forest put:
        '      /\\        /\\      
      /  \\      /  \\     
     /____\\    /____\\    
   /\\  ||   /\\   ||  /\\  
  /__\\ ||  /__\\  || /__\\ 
   ||  ||   ||   ||  ||  
 A shady forest. Birds chirp in the trees.
 It smells like adventure... and maybe snacks.
 '.

        locations at: #lowForest put:
        '  /\\                  
  /__\\       /\\         
   ||       /__\\        
 vvVvVvv   vv||vvVvVvv     
 The forest here is thinner.
 You can still see the tall grass where the cage fell.
 '.

        locations at: #infiniteForest put:
        '  /\\  /\\  /\\  /\\  /\\
  /__\\/__\\/__\\/__\\/__\\ 
   ||  ||  ||  ||  ||  
 Trees stretch endlessly in every direction.
 The forest looks exactly the same everywhere.
 Muffin is completely lost.
 '.

        locations at: #road put:
        '   __________   
                
  ===  ===  === 
              
 A dusty road where the truck drove away.
 You see tire tracks leading north.
 Some trash is laying on the side of the road.
 '.
    
        locations at: #rockyRoad put:
        '  __________   
  .o .  o .  o   
  ===  ===  === 
  o .  .  o . .  
 A rough rocky road full of stones.
 Seven carved stones lie on the ground.
 Letters on them read: h, l, e, t, s, r, e
 Maybe they can form a word...
 '.
    
        locations at: #meadow put:
        '    _     _     _      
    ( )   ( )   ( )   __ 
     |     |     |   (  )
    \\|/   \\|/   \\|/  (__)
 A quiet meadow full of pretty flowers.
 Something shiny lies under a white_rock.
 '.
    
        locations at: #car put:
        '      _______      
     _/_|     \\_    
    |_|_______|_|   
  ----(o)---(o)----  
 A parked farm car stands behind the barn.
 The engine suddenly rumbles to life...
 '.

        locations at: #river put:
        '  ~ ~ ~ ~ ~ ~ ~ ~  
    <><    <><      
    ~ ~ ~ ~ ~ ~ ~   
   ~ ~ ~ ~ ~ ~ ~ ~  
 A fast flowing river blocks your path to the west.
 You can see fish swimming in the water.
 The current looks very strong.
 '.

        locations at: #waterfall put:
        '     | | | |       
      | | | |       
      | | | |       
   _~~_~~_~~_~~_    
  (_____________)   
 A beautiful waterfall blocks your path to the west-north.
 This might be a peaceful place to arrange something and rest in its shade.
 The smooth stones by the water look perfect for stacking.
 Muffin notices that some are large and heavy, while others are small and light.
 Three stones and a shell together could make a small totem if placed carefully.
 Perhaps they should stand from the strongest base to the lightest top.
 If only she could remember the first sounds of their names...
 '.

        locations at: #barn put:
        '      _______      
      / _____ \\     
     / /|_|_|\\ \\    
     |_|  _  |_|    
 vVvV|_| | | |_|vVvVv 
 An old wooden barn. It smells like mice.
 Sadly, they are all hiding.
 '.

        locations at: #town put:
        '  |  |_______|  |  
   |   _     _   |  
   |  |_| ^ |_|  |  
   |     |V|     |  
   |    / m \\    |  
 You arrive at a small town street.
 A big dog sits at the south of the road and barks at you. He doesn''t like cats, especially ones that look a bit familiar.
 '.

        locations at: #wheatField put:
        '   \\/  \\/  \\/  \\/  
    \\/  \\/  \\/  \\/  
   _|   |  _|   |   
  (_)     (_)           
 A huge wheat field sways in the wind.
 You see a bundle of hay here.
 To the west lies a cabbage field.
 '.
        
        locations at: #cabbageField put:
        '  \\(w)/  \\(w)/  \\(w)/ 
    ""     ""     ""   
 \\(w)/  \\(w)/  \\(w)/ 
  ""     ""     ""   
 Rows of cabbage stretch across the field.
 Crows sit everywhere watching suspiciously.
 '.

        locations at: #bridge put:
        '   __________      
   |__________|     
   | |      | |     
   | |  ~~  | |     
      ~~~~ ~~     
 A wooden bridge crosses a small stream.
 The town is just beyond it.'.

        locations at: #graveyard put:
        '  _|_   ___   _|_  
  |   | | o | |   | 
  |___| |___| |___| 
  , ` , ` , ` , ` , 
 An old graveyard full of crooked tombstones.
 Cold wind rustles the dead leaves.
 Tall stone walls surround the graveyard on all sides.
 The only exit is back east towards the town.
 '.

        locations at: #home put:
        '          ( (        
           ) )        
      ____|_|____     
     /-  -  -  - \\    
    /__-___-__-__-\\   
     |   _  _   _    |  
     |  |_||_| | |   |  
 __|_________|_|___|__
  vvVvVVvVvvvVvvVvVvv 
 Your house!
 The warm sofa awaits.
 '.
 
        ^ locations.
    ]
]

