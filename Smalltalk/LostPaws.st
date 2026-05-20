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

    showLocation [
        Transcript show: location; cr.
        Transcript show: (Descriptions locations at: location); cr.
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

]

LostPaws new run.