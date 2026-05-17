Object subclass: LostPaws [
    | running |

    LostPaws class >> start [
        | game |
        game := self new.
        game run.
    ]

    run [
        running := true.

        self title.
        self instructions.

        [ running ] whileTrue: [
            | input |

            Transcript show: '> '.

            input := stdin nextLine asLowercase.

            input = 'quit'
                ifTrue: [
                    running := false.
                    Transcript show: 'Bye!'; cr.
                ]
                ifFalse: [
                    self handleCommand: input.
                ].
        ].
    ]

    handleCommand: input [

        input = 'help'
            ifTrue: [
                self instructions.
                ^self
            ].

        Transcript
            show: 'Unknown command.';
            cr.
    ]

    title [
        Transcript cr.
        Transcript show: ('============================================================'); cr.
        Transcript show: '  _                 _  _____                         '; cr.
        Transcript show: ' | |               | | |  __ \\                        '; cr.
        Transcript show: ' | |      ___  ___ | |_| |__) |__ __      __ ___     '; cr.
        Transcript show: ' | |     / _ \\/ __|| __|  ___/ _ `\\ \\ /\\ / // __|    '; cr.
        Transcript show: ' | |____| (_) \\__ \\| |_| |  | (_| |\\ V  V / \\__ \\    '; cr.
        Transcript show: ' |______|\\___/|___/ \\__|_|   \\__,_| \\_/\\_/  |___/    '; cr.
        Transcript show: '============================================================'; cr.
        Transcript show: '         THE JOURNEY BEGINS - find your way home           '; cr.
        Transcript show: '============================================================'; cr.
        Transcript show: '                       |\\__/,|   (`\\'; cr.
        Transcript show: '                     _.|o o  |_   ) )'; cr.
        Transcript show: '                   -(((---(((--------'; cr.
        Transcript show: '============================================================'; cr.
        Transcript cr.
    ]

    instructions [
        Transcript cr.
        Transcript show: 'Commands:'; cr.
        Transcript show: 'help   - show help'; cr.
        Transcript show: 'quit   - exit game'; cr.
        Transcript cr.
    ]
]

LostPaws start.