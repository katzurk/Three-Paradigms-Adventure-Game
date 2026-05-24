FileStream fileIn: 'Descriptions.st'.
FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.
FileStream fileIn: 'World.st'.

Object subclass: LostPaws [
    | isOver location world hunger mouth 
    eagleDistracted scarecrowBuilt stairsBuilt
    dogDistracted shelterClueFound|

    LostPaws class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isOver := false.
        location := #startCage.
        world := World build.
        hunger := 0.
        mouth := OrderedCollection new.
        eagleDistracted := false.
        scarecrowBuilt := false.
        stairsBuilt := false.
        dogDistracted := false.
    ]

    readDescription: target [
        Transcript show: (Descriptions perform: target); cr.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    increaseHunger [
        hunger := hunger + 1.
        hunger >= 12
            ifTrue: [
                Transcript show: 'Muffin is too weak to take another step...' ; cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
            ].
    ]

    showHunger [
        Transcript show: '[hunger ', hunger asString, '/12]'; cr.
    ]

    showMouth [
        Transcript show: 'Muffin is carrying: '; cr.
        mouth isEmpty
            ifTrue: [
                Transcript show: 'Nothing. Her mouth is empty.'; cr.
            ]
            ifFalse: [
                mouth do: [ :obj |
                    Transcript show: '- ', obj name asString; cr.
                ].
                Transcript show: 'That is everything in her mouth.'; cr.
            ].

    ]

    showLocation [
        | loc |

        loc := world at: location.

        Transcript show: location; cr.
        Transcript show: (Descriptions locations at: location); cr.

        loc objects isEmpty
        ifFalse: [

            loc objects do: [ :obj |
                Transcript show: 'There is a ', obj name asString, ' here.'; cr.
            ].
        ].
    ]

    run [
        | cmd |
        self readDescription: #title.
        self readDescription: #introduction.
        self readDescription: #instructions.
        self showHunger.
        self showLocation.

        [ isOver ] whileFalse: [

            cmd := self readCommand.

            self handleCommand: cmd.
        ]
    ]

    handleCommand: cmd [
        | parts dir object |

        parts := cmd subStrings: ' '.

        cmd = 'help'
            ifTrue: [
                Transcript show: Descriptions instructions; cr.
                ^self
            ].
        cmd = 'look'
            ifTrue: [
                self showHunger.
                self showLocation.
                ^self
            ].
        cmd = 'show mouth'
            ifTrue: [
                self showMouth.
                ^self
            ].
        (parts first = 'move')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: move [n/w/s/e]'; cr.
                    ^ self
                ].
                dir := parts second asSymbol.
            self move: dir.
            ^ self
            ].
        (parts first = 'search')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: search [a]'; cr.
                    ^ self
                ].
                object := parts second asSymbol.
                self search: object.
                ^ self
            ].
        (parts first = 'take')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: take [a]'; cr.
                    ^ self
                ].
                self take: parts second asSymbol.
                ^ self
            ].
        (parts first = 'drop')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: drop [a]'; cr.
                    ^ self
                ].
                self drop: parts second asSymbol.
                ^ self
            ].
        (parts first = 'eat')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: eat [a]'; cr.
                    ^ self
                ].
                self eat: parts second asSymbol.
                ^ self
            ].
        (parts first = 'attach')
            ifTrue: [
                parts size < 4 ifTrue: [
                    Transcript show: 'Usage: attach [a] to [b]'; cr.
                    ^ self
                ].
                self attach: (parts second asSymbol)
                    to: (parts fourth asSymbol).
                ^ self
            ].
        (parts first = 'arrange')
            ifTrue: [
                parts size < 2 ifTrue: [
                    Transcript show: 'Usage: arrange [a, b, c...]'; cr.
                    ^ self
                ].
                self arrange: (parts allButFirst collect: [ :x | x asSymbol ]).
                ^ self
            ].
        cmd = 'quit'
            ifTrue: [
                isOver := true.
                Transcript show: 'Bye!'; cr.
                ^self
            ].

        Transcript
            show: 'Unknown command.';
            cr.
    ]

    move: direction [
        | loc next |

        loc := world at: location.

        ((#(#wheatField #cabbageField #town) includes: location) 
            and: [ direction = #n ]) ifTrue:[
                Transcript show: 'There is a highway up ahead.'; cr.
                Transcript show: 'Muffin is too scared to go this way.'; cr.
                ^ self
            ].
        next := loc pathAt: direction.

        next isNil
            ifTrue: [
                Transcript show: 'You can''t go that way.'; cr.
                ^ self
            ].

        (location = #town and: [ dogDistracted not and: [ direction = #s ] ])
            ifTrue: [
                Transcript show: 'A big dog blocks your way to the south and growls.'; cr.
                Transcript show: 'Maybe you could give him something to eat...'; cr.
                ^ self
            ].

        (location = #town and: [ eagleDistracted not and: [ direction = #s ] ])
            ifTrue: [
                Transcript show: 'As Muffin walks forward...'; cr.
                Transcript show: 'A huge eagle swoops down from above!'; cr.
                Transcript show: 'Its talons grab Muffin before she can react.'; cr.
                Transcript show: 'The ground fades away...'; cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                ^ self
            ].

        (location = #wheatField and: [ scarecrowBuilt not and: [ direction = #w ] ])
            ifTrue: [
                Transcript show: 'As Muffin enters the cabbage field...'; cr.
                Transcript show: 'A flock of angry crows attacks!'; cr.
                Transcript show: 'CAW! CAW!'; cr.
                Transcript show: 'They chase Muffin back to the wheat field.'; cr.
                ^ self
            ].

        (location = #bridge and: [ stairsBuilt not and: [ direction = #w ] ])
            ifTrue: [
                Transcript show: 'A tall stone gate, flanked by two castle towers, blocks the entrance to the town.'; cr.
                Transcript show: 'Muffin could jump over... if she was taller.'; cr.
                Transcript show: 'Maybe she could build something to climb on.'; cr.
                ^ self
            ].

        self increaseHunger.
        isOver ifTrue: [ ^ self ].
        location := next.
        location = #lake 
            ifTrue: [
                Transcript show: 'Muffin visits the lake.'; cr.
                Transcript show: 'But the ground is slippery here!'; cr.
                Transcript show: 'She falls into the water. Muffin can''t swim and drowns.'; cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                ^ self
            ].
        location = #car 
            ifTrue: [
                self showLocation.
                Transcript show: 'Muffin sneaks behind the barn into a parking lot.'; cr.
                Transcript show: 'Suddenly a car starts moving!'; cr.
                Transcript show: 'She is disoriented and runs directly under the wheels...'; cr.
                Transcript show: 'CRUNCH.'; cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                ^ self
            ].
        location = #home 
            ifTrue: [
                self showLocation.
                Transcript show: 'Muffin recognizes the smell of her house!'; cr.
                Transcript show: 'She waddles inside and jumps onto the sofa.'; cr.
                Transcript show: 'Home at last.'; cr.
                Transcript show: 'YOU WIN!'; cr.
                isOver := true.
                ^ self
            ].
        location = #shelter
            ifTrue: [
                self showLocation.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                ^ self
            ].

        self showHunger.
        self showLocation.
    ]

    search: objectName [
        | loc obj found |
        loc := world at: location.
        objectName = #river ifTrue: [
            location = #river
                ifTrue: [
                    Transcript show: 'Muffin splashes the water with her paw.'; cr.
                    Transcript show: 'She finds a shiny coolPebble!'; cr.
                    obj := GameObject named: #coolPebble.
                    loc addObject: obj.
                ]
                ifFalse: [
                    Transcript show: 'There is no river here.'; cr.
                ].

            ^ self
        ].

        obj := loc objects detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: objectName asString, ' not found.'; cr.
            ^ self
        ].
        found := obj contains first.

        Transcript show: 'Muffin searches the ', objectName asString, ' and finds '; cr.

        obj contains isEmpty 
            ifTrue: [
                Transcript show: 'nothing else inside.'; cr.
            ]
            ifFalse: [
                loc addObject: found.
                obj contains remove: found.
                Transcript show: '- ', found name asString; cr.
            ].
    ]

    take: objectName [
        | loc objs obj |

        loc := world at: location.

        (objectName = #river and: [location = #river]) ifTrue: [
            Transcript show: 'The river is way too big for Muffin to pick up.'; cr.
            ^ self
        ].
        objs := loc objects.

        obj := objs detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'You do not see that here.'; cr.
            ^ self
        ].

        mouth size >= 3 ifTrue: [
            Transcript show: 'Muffin tries to pick up the ', objectName asString, '.'; cr.
            Transcript show: 'But her tiny cat mouth is already full.'; cr.
            ^ self
        ].

        objectName = #whiteRock ifTrue: [
            obj contains do: [ :each | loc addObject: each ].
            obj empty.
        ].

        objectName = #dog ifTrue: [
            Transcript show: 'The dog is far too big and angry for Muffin to pick up.'; cr.
            ^ self
        ].

        objectName = #sofa ifTrue: [
            Transcript show: 'The sofa is too heavy for Muffin to move.'; cr.
            ^ self
        ].

        objs remove: obj.
        mouth add: obj.

        Transcript show: 'You pick up the ', objectName, '.'; cr.
    ]

    drop: objectName [
        | loc obj |

        loc := world at: location.

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'You are not holding it.'; cr.
            ^ self
        ].

        (location = #town and: [ objectName = #bone ])
            ifTrue: [
                Transcript show: 'The dog grabs the bone and runs away happily!'; cr.
                dogDistracted := true.
                mouth remove: obj.
                ^ self
            ].

        ( (World fish includes: objectName)
            and: [ location = #town ]) ifTrue:[
                Transcript show: 'An eagle swoops down and grabs the fish!'; cr.
                Transcript show: 'It flies away with its meal.'; cr.
                eagleDistracted := true.
                mouth remove: obj.
                ^ self
            ].

        mouth remove: obj.
        loc addObject: obj.

        Transcript show: 'Dropped.'; cr.        
    ]

    eat: objectName [
        | obj |

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'You are not holding it.'; cr.
            ^ self
        ].

        (World fish includes: objectName) ifTrue: [
            hunger := hunger - 3.
            hunger < 0 ifTrue: [ hunger := 0 ].
            Transcript show: (Descriptions eatDescriptions at: #fish); cr.
            mouth remove: obj.
            ^ self
        ].

        (World rodents includes: objectName) ifTrue: [
            hunger := hunger - 2.
            hunger < 0 ifTrue: [ hunger := 0 ].
            Transcript show: (Descriptions eatDescriptions at: #rodent); cr.
            mouth remove: obj.
            ^ self
        ].

        objectName = #catnip
            ifTrue: [
                Transcript show: (Descriptions eatDescriptions at: #catnip); cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                mouth remove: obj.
                ^ self
            ].

        objectName = #chocolate
            ifTrue: [
                Transcript show: (Descriptions eatDescriptions at: #chocolate); cr.
                Transcript show: 'YOU LOSE!'; cr.
                isOver := true.
                mouth remove: obj.
                ^ self
            ].  

        Transcript show: (Descriptions eatDescriptions at: #default); cr.
    ]

    attach: objectName to: baseName [
        | loc obj base |

        loc := world at: location.

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'You do not have  that item.'; cr.
            ^ self
        ].

        base := loc objects detect: [ :o | o name = baseName ] ifNone: [ nil ].

        base isNil ifTrue: [
            Transcript show: 'The second item is not here.'; cr.
            ^ self
        ].

        (objectName = #bigStick and: [ baseName = #hay ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    Transcript show: 'You need to build the frame near the wheatField'; cr.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #frame).

                Transcript show: 'You attach a stick into the hay bundle.'; cr.
                Transcript show: 'It starts to look like a frame.'; cr.
                ^ self
            ].
        (objectName = #smallStick and: [ baseName = #frame ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    Transcript show: 'You need to build the frame near the wheatField'; cr.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #headlessMan).

                Transcript show: 'The scarecrow now has two arms..'; cr.
                Transcript show: 'It looks like a headless man!'; cr.
                ^ self
            ].
        (objectName = #hat and: [ baseName = #headlessMan ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    Transcript show: 'You need to build the frame near the wheatField'; cr.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #scarecrow).
                scarecrowBuilt := true.

                Transcript show: 'You place the hat on top.'; cr.
                Transcript show: 'A scary scarecrow stands between the fields!'; cr.
                Transcript show: 'The crows fly away.'; cr.
                ^ self
            ].
        (objectName = #pipe and: [ baseName = #brokenStool ])
            ifTrue: [
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #stool).

                Transcript show: 'You fix the broken stool using the pipe.'; cr.
                ^ self
            ].
        (objectName = #cardboardBox and: [ baseName = #cage ])
            ifTrue: [
                (location = #bridge)
                ifFalse: [
                    Transcript show: 'You need to build the tower near the bridge'; cr.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #tower).

                Transcript show: 'You place the cardboard box on top of the cage.'; cr.
                Transcript show: 'It forms a small tower.'; cr.
                ^ self
            ].
        (objectName = #stool and: [ baseName = #tower ])
            ifTrue: [
                (location = #bridge)
                ifFalse: [
                    Transcript show: 'You need to build the stairs near the bridge'; cr.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #stairs).
                stairsBuilt := true.

                Transcript show: 'You add the stool to the tower.'; cr.
                Transcript show: 'Now Muffin can climb it like stairs!'; cr.
                ^ self
            ].

        Transcript show:
            'Those things cannot be attached together.'; cr.
    ]

    arrange: symbols [
        | loc word |
        word := String streamContents: [ :s |symbols do: [ :x | s nextPutAll: x asString. ].].
        loc := world at: location.
        (location = #rockyRoad and: [ symbols size = 7 ])
            ifTrue: [
                (word = 'shelter')
                    ifTrue: [
                        Transcript show: 'The stones glow faintly...'; cr.
                        Transcript show: 'SHELTER.'; cr.
                        Transcript show: 'Muffin suddenly understands!'; cr.
                        Transcript show: 'The animal shelter must be south of here!'; cr.
                        Transcript show: 'I don''t want to live in a cage!'; cr.
                        Transcript show: 'Something shiny appears between the stones... a shell!'; cr.
                        loc addObject: (GameObject named: #shell).
                    ]
                    ifFalse: [
                        Transcript show: 'The stones do not form a meaningful word.'; cr.
                    ].
                ^ self
            ].
        (location = #waterfall and: [ symbols size = 4 ])
            ifTrue: [
                | needed isAll pipe |

                needed := #(#brick #whiteRock #coolPebble #shell).

                isAll := needed allSatisfy: [ :req | loc objects anySatisfy: [ :o | o name = req ]].

                isAll ifFalse: [
                    Transcript show: 'You do not have all the stones needed to build the totem.'; cr.
                ].
                (word = 'bwcs')
                    ifTrue: [
                        Transcript show: 'Muffin carefully stacks the stones into a small totem.'; cr.
                        Transcript show: 'Brick at the bottom, then white rock, cool pebble and shell.'; cr.
                        Transcript show: 'The rushing waterfall sounds pleasant and she feels safe.'; cr.
                        Transcript show: 'Something floats toward the shore... a metal pipe washes up!'; cr.
                        pipe := GameObject named: #pipe.
                        pipe addObject: (GameObject named: #herring).
                        loc addObject: pipe.
                    ]
                    ifFalse: [
                        'That''s not the right order or items for the totem.'
                    ].
                ^ self
            ].

        Transcript show:
            'That arrangement makes no sense here.'; cr.
    ]
].

LostPaws new run.