FileStream fileIn: 'Descriptions.st'.

Object subclass: LostPaws [
    | isOver location |

    LostPaws class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isOver := false.
        location := #startCage
    ]

    readDescription: target [
        Transcript show: (Descriptions perform: target); cr.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    run [
        | cmd |
        self readDescription: #title.
        self readDescription: #introduction.
        self readDescription: #instructions.

        [isOver] whileFalse: [

            cmd := self readCommand.

            self handleCommand: cmd.
        ]
    ]

    handleCommand: cmd [

        cmd = 'help'
            ifTrue: [
                Transcript show: Descriptions instructions; cr.
                ^self
            ].
        cmd = 'look'
            ifTrue: [
                Transcript show: (Descriptions locations at: location); cr.
                ^self
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

]

LostPaws new run.