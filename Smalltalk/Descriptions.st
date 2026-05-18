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
    

        ^ locations.
    ]
]

