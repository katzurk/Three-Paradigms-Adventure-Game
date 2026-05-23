FileStream fileIn: 'Descriptions.st'.
FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.
FileStream fileIn: 'World.st'.

Object subclass: LostPaws [
    | isOver location world hunger mouth 
    solveShelterPuzzle |

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
        solveShelterPuzzle := true.
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
                dir := parts second asSymbol.
            self move: dir.
            ^ self
            ].
        (parts first = 'search')
            ifTrue: [
                object := parts second asSymbol.
                self search: object.
                ^ self
            ].
        (parts first = 'take')
            ifTrue: [
                self take: parts second asSymbol.
                ^ self
            ].
        (parts first = 'drop')
            ifTrue: [
                self drop: parts second asSymbol.
                ^ self
            ].
        (parts first = 'eat')
            ifTrue: [
                self eat: parts second asSymbol.
                ^ self
            ].
        (parts first = 'attach')
            ifTrue: [
                self attach: (parts second asSymbol)
                    to: (parts fourth asSymbol).
                ^ self
            ].
        (parts first = 'arrange')
            ifTrue: [
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

        next := loc pathAt: direction.

        next isNil
            ifTrue: [
                Transcript show: 'You can''t go that way.'; cr.
                ^ self
            ].

        self increaseHunger.
        location := next.
        self showHunger.
        self showLocation.
    ]

    search: objectName [
        | loc obj |
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
  
        obj contains do: [ :each |
            loc objects add: each
        ].

        Transcript show: 'Muffin searches the ', objectName asString, ' and finds '; cr.

        obj contains isEmpty 
            ifTrue: [
                Transcript show: 'nothing else inside.'; cr.
            ]
            ifFalse: [
                obj contains do: [ :each |
                    Transcript show: '- ', each name asString; cr.
                ].
            ].

        obj empty.
    ]

    take: objectName [
        | loc objs obj |

        loc := world at: location.
        objs := loc objects.

        obj := objs detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'There is no ', objectName, ' here.'; cr.
            ^ self
        ].

        mouth size >= 3 ifTrue: [
            Transcript show: 'Muffin''s mouth is full!'; cr.
            ^ self
        ].

        objs remove: obj.
        mouth add: obj.

        Transcript show: 'Taken: ', objectName; cr.
    ]

    drop: objectName [
        | loc obj |

        loc := world at: location.

        obj := mouth detect: [ :o | o name = objectName ] ifNone: [ nil ].

        obj isNil ifTrue: [
            Transcript show: 'You are not holding it.'; cr.
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
                isOver := true.
                mouth remove: obj.
                ^ self
            ].

        objectName = #chocolate
            ifTrue: [
                Transcript show: (Descriptions eatDescriptions at: #chocolate); cr.
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
            Transcript show: 'You do not have that obj.'; cr.
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
                        solveShelterPuzzle := true.
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
    ].
]

LostPaws new run.