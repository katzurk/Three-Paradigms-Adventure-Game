FileStream fileIn: 'Descriptions.st'.
FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.
FileStream fileIn: 'World.st'.

Object subclass: LostPaws [
    | isOver location world hunger mouth |

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
        | parts dir object|

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

]

LostPaws new run.