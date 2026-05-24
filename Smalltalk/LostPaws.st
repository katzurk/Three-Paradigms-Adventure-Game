FileStream fileIn: 'Descriptions.st'.
FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.
FileStream fileIn: 'World.st'.

Object subclass: LostPaws [
    | isOver location world hunger mouth 
    eagleDistracted scarecrowBuilt stairsBuilt
    dogDistracted shelterClueFound logFile |

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
        logFile := FileStream open: 'game.log' mode: #write.
    ]

    readDescription: target [
        self printText: (Descriptions perform: target).
    ]

    readCommand [
        | cmd |
        Transcript show: '> '.
        cmd := FileStream stdin nextLine.
        logFile nextPutAll: '> ', cmd; nl.
        ^ cmd
    ]

    increaseHunger [
        hunger := hunger + 1.
        hunger >= 12
            ifTrue: [
                self printText: 'Muffin is too weak to take another step...' .
                self loseGame.
            ].
    ]

    decreaseHunger: points [
        hunger := hunger - points.
        hunger < 0 ifTrue: [ hunger := 0 ].
    ]

    removeFromMouth: obj [
        mouth remove: obj.
    ]

    showHunger [
        self printText: '[hunger ', hunger asString, '/12]'.
    ]

    loseGame [
        isOver := true.
        self printText: 'YOU LOSE!'.
    ]

    showMouth [
        self printText: 'Muffin is carrying: '.
        mouth isEmpty
            ifTrue: [
                self printText: 'Nothing. Her mouth is empty.'.
            ]
            ifFalse: [
                mouth do: [ :obj |
                    self printText: '- ', obj name asString.
                ].
                self printText: 'That is everything in her mouth.'.
            ].

    ]

    showLocation [
        | loc |

        loc := world at: location.

        self printText: location.
        self printText: (Descriptions locations at: location).

        loc objects isEmpty
        ifFalse: [

            loc objects do: [ :obj |
                self printText: 'There is a ', obj name asString, ' here.'.
            ].
        ].
    ]

    printText: text [
        Transcript show: text; cr.
        logFile nextPutAll: text; nl.
    ]

    closeLog [
        logFile close.
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
        ].
        self closeLog.
    ]

    handleCommand: cmd [
        | parts dir object |

        parts := cmd subStrings: ' '.

        cmd = 'help'
            ifTrue: [
                self printText: Descriptions instructions.
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
                    self printText: 'Usage: move [n/w/s/e]'.
                    ^ self
                ].
                dir := parts second asSymbol.
            self move: dir.
            ^ self
            ].
        (parts first = 'search')
            ifTrue: [
                parts size < 2 ifTrue: [
                    self printText: 'Usage: search [a]'.
                    ^ self
                ].
                object := parts second asSymbol.
                self search: object.
                ^ self
            ].
        (parts first = 'take')
            ifTrue: [
                parts size < 2 ifTrue: [
                    self printText: 'Usage: take [a]'.
                    ^ self
                ].
                self take: parts second asSymbol.
                ^ self
            ].
        (parts first = 'drop')
            ifTrue: [
                parts size < 2 ifTrue: [
                    self printText: 'Usage: drop [a]'.
                    ^ self
                ].
                self drop: parts second asSymbol.
                ^ self
            ].
        (parts first = 'eat')
            ifTrue: [
                parts size < 2 ifTrue: [
                    self printText: 'Usage: eat [a]'.
                    ^ self
                ].
                self eat: parts second asSymbol.
                ^ self
            ].
        (parts first = 'attach')
            ifTrue: [
                parts size < 4 ifTrue: [
                    self printText: 'Usage: attach [a] to [b]'.
                    ^ self
                ].
                self attach: (parts second asSymbol)
                    to: (parts fourth asSymbol).
                ^ self
            ].
        (parts first = 'arrange')
            ifTrue: [
                parts size < 2 ifTrue: [
                    self printText: 'Usage: arrange [a, b, c...]'.
                    ^ self
                ].
                self arrange: (parts allButFirst collect: [ :x | x asSymbol ]).
                ^ self
            ].
        cmd = 'quit'
            ifTrue: [
                isOver := true.
                self printText: 'Bye!'.
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
                self printText: 'There is a highway up ahead.'.
                self printText: 'Muffin is too scared to go this way.'.
                ^ self
            ].
        next := loc pathAt: direction.

        next isNil
            ifTrue: [
                self printText: 'You can''t go that way.'.
                ^ self
            ].

        (location = #town and: [ dogDistracted not and: [ direction = #s ] ])
            ifTrue: [
                self printText: 'A big dog blocks your way to the south and growls.'.
                self printText: 'Maybe you could give him something to eat...'.
                ^ self
            ].

        (location = #town and: [ eagleDistracted not and: [ direction = #s ] ])
            ifTrue: [
                self printText: 'As Muffin walks forward...'.
                self printText: 'A huge eagle swoops down from above!'.
                self printText: 'Its talons grab Muffin before she can react.'.
                self printText: 'The ground fades away...'.
                self loseGame.
                ^ self
            ].

        (location = #wheatField and: [ scarecrowBuilt not and: [ direction = #w ] ])
            ifTrue: [
                self printText: 'As Muffin enters the cabbage field...'.
                self printText: 'A flock of angry crows attacks!'.
                self printText: 'CAW! CAW!'.
                self printText: 'They chase Muffin back to the wheat field.'.
                ^ self
            ].

        (location = #bridge and: [ stairsBuilt not and: [ direction = #w ] ])
            ifTrue: [
                self printText: 'A tall stone gate, flanked by two castle towers, blocks the entrance to the town.'.
                self printText: 'Muffin could jump over... if she was taller.'.
                self printText: 'Maybe she could build something to climb on.'.
                ^ self
            ].

        self increaseHunger.
        isOver ifTrue: [ ^ self ].
        location := next.
        location = #lake 
            ifTrue: [
                self printText: 'Muffin visits the lake.'.
                self printText: 'But the ground is slippery here!'.
                self printText: 'She falls into the water. Muffin can''t swim and drowns.'.
                self loseGame.
                ^ self
            ].
        location = #car 
            ifTrue: [
                self showLocation.
                self printText: 'Muffin sneaks behind the barn into a parking lot.'.
                self printText: 'Suddenly a car starts moving!'.
                self printText: 'She is disoriented and runs directly under the wheels...'.
                self printText: 'CRUNCH.'.
                self loseGame.
                ^ self
            ].
        location = #home 
            ifTrue: [
                self showLocation.
                self printText: 'Muffin recognizes the smell of her house!'.
                self printText: 'She waddles inside and jumps onto the sofa.'.
                self printText: 'Home at last.'.
                self printText: 'YOU WIN!'.
                isOver := true.
                ^ self
            ].
        location = #shelter
            ifTrue: [
                self showLocation.
                self loseGame.
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
                    self printText: 'Muffin splashes the water with her paw.'.
                    self printText: 'She finds a shiny coolPebble!'.
                    obj := GameObject named: #coolPebble.
                    loc addObject: obj.
                ]
                ifFalse: [
                    self printText: 'There is no river here.'.
                ].

            ^ self
        ].

        obj := loc objects detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            self printText: objectName asString, ' not found.'.
            ^ self
        ].
        found := obj contains first.

        self printText: 'Muffin searches the ', objectName asString, ' and finds '.

        obj contains isEmpty 
            ifTrue: [
                self printText: 'nothing else inside.'.
            ]
            ifFalse: [
                loc addObject: found.
                obj contains remove: found.
                self printText: '- ', found name asString.
            ].
    ]

    take: objectName [
        | loc objs obj |

        loc := world at: location.

        (objectName = #river and: [location = #river]) ifTrue: [
            self printText: 'The river is way too big for Muffin to pick up.'.
            ^ self
        ].
        objs := loc objects.

        obj := objs detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            self printText: 'You do not see that here.'.
            ^ self
        ].

        mouth size >= 3 ifTrue: [
            self printText: 'Muffin tries to pick up the ', objectName asString, '.'.
            self printText: 'But her tiny cat mouth is already full.'.
            ^ self
        ].

        (obj canBeTaken) ifTrue: [
            objectName = #whiteRock ifTrue: [
                obj contains do: [ :each | loc addObject: each ].
                obj empty.
            ].
            objs remove: obj.
            mouth add: obj.
        ].
        obj onTakeBy: self.
    ]

    drop: objectName [
        | loc obj |

        loc := world at: location.

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            self printText: 'You are not holding it.'.
            ^ self
        ].

        (location = #town and: [ objectName = #bone ])
            ifTrue: [
                self printText: 'The dog grabs the bone and runs away happily!'.
                dogDistracted := true.
                mouth remove: obj.
                ^ self
            ].

        ( (obj isKindOf: Fish)
            and: [ location = #town ]) ifTrue:[
                self printText: 'An eagle swoops down and grabs the fish!'.
                self printText: 'It flies away with its meal.'.
                eagleDistracted := true.
                mouth remove: obj.
                ^ self
            ].

        mouth remove: obj.
        loc addObject: obj.

        self printText: 'Dropped.'.        
    ]

    eat: objectName [
        | obj |

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            self printText: 'You are not holding it.'.
            ^ self
        ].

        obj onEatBy: self.

    ]

    attach: objectName to: baseName [
        | loc obj base |

        loc := world at: location.

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            self printText: 'You do not have  that item.'.
            ^ self
        ].

        base := loc objects detect: [ :o | o name = baseName ] ifNone: [ nil ].

        base isNil ifTrue: [
            self printText: 'The second item is not here.'.
            ^ self
        ].

        (objectName = #bigStick and: [ baseName = #hay ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    self printText: 'You need to build the frame near the wheatField'.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #frame).

                self printText: 'You attach a stick into the hay bundle.'.
                self printText: 'It starts to look like a frame.'.
                ^ self
            ].
        (objectName = #smallStick and: [ baseName = #frame ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    self printText: 'You need to build the frame near the wheatField'.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #headlessMan).

                self printText: 'The scarecrow now has two arms..'.
                self printText: 'It looks like a headless man!'.
                ^ self
            ].
        (objectName = #hat and: [ baseName = #headlessMan ])
            ifTrue: [
                (location = #wheatField)
                ifFalse: [
                    self printText: 'You need to build the frame near the wheatField'.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #scarecrow).
                scarecrowBuilt := true.

                self printText: 'You place the hat on top.'.
                self printText: 'A scary scarecrow stands between the fields!'.
                self printText: 'The crows fly away.'.
                ^ self
            ].
        (objectName = #pipe and: [ baseName = #brokenStool ])
            ifTrue: [
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #stool).

                self printText: 'You fix the broken stool using the pipe.'.
                ^ self
            ].
        (objectName = #cardboardBox and: [ baseName = #cage ])
            ifTrue: [
                (location = #bridge)
                ifFalse: [
                    self printText: 'You need to build the tower near the bridge'.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #tower).

                self printText: 'You place the cardboard box on top of the cage.'.
                self printText: 'It forms a small tower.'.
                ^ self
            ].
        (objectName = #stool and: [ baseName = #tower ])
            ifTrue: [
                (location = #bridge)
                ifFalse: [
                    self printText: 'You need to build the stairs near the bridge'.
                    ^ self
                ].
                mouth remove: obj.
                loc objects remove: base.

                loc addObject: (GameObject named: #stairs).
                stairsBuilt := true.

                self printText: 'You add the stool to the tower.'.
                self printText: 'Now Muffin can climb it like stairs!'.
                ^ self
            ].

        self printText:
            'Those things cannot be attached together.'.
    ]

    arrange: symbols [
        | loc word |
        word := String streamContents: [ :s |symbols do: [ :x | s nextPutAll: x asString. ].].
        loc := world at: location.
        (location = #rockyRoad and: [ symbols size = 7 ])
            ifTrue: [
                (word = 'shelter')
                    ifTrue: [
                        self printText: 'The stones glow faintly...'.
                        self printText: 'SHELTER.'.
                        self printText: 'Muffin suddenly understands!'.
                        self printText: 'The animal shelter must be south of here!'.
                        self printText: 'I don''t want to live in a cage!'.
                        self printText: 'Something shiny appears between the stones... a shell!'.
                        loc addObject: (GameObject named: #shell).
                    ]
                    ifFalse: [
                        self printText: 'The stones do not form a meaningful word.'.
                    ].
                ^ self
            ].
        (location = #waterfall and: [ symbols size = 4 ])
            ifTrue: [
                | needed isAll pipe |

                needed := #(#brick #whiteRock #coolPebble #shell).

                isAll := needed allSatisfy: [ :req | loc objects anySatisfy: [ :o | o name = req ]].

                isAll ifFalse: [
                    self printText: 'You do not have all the stones needed to build the totem.'.
                ].
                (word = 'bwcs')
                    ifTrue: [
                        self printText: 'Muffin carefully stacks the stones into a small totem.'.
                        self printText: 'Brick at the bottom, then white rock, cool pebble and shell.'.
                        self printText: 'The rushing waterfall sounds pleasant and she feels safe.'.
                        self printText: 'Something floats toward the shore... a metal pipe washes up!'.
                        pipe := GameObject named: #pipe.
                        pipe addObject: (Rodent named: #herring).
                        loc addObject: pipe.
                    ]
                    ifFalse: [
                        'That''s not the right order or items for the totem.'
                    ].
                ^ self
            ].

        self printText:
            'That arrangement makes no sense here.'.
    ]
].

LostPaws new run.