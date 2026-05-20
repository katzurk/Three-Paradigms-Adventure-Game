FileStream fileIn: 'Descriptions.st'.
FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.
FileStream fileIn: 'World.st'.

Object subclass: LostPaws [
    | isOver location world|

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

        [ isOver ] whileFalse: [

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