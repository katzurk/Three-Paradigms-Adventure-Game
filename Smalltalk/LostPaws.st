FileStream fileIn: 'Descriptions.st'.

Object subclass: LostPaws [
    | running location |

    LostPaws class >> start [
        | game |
        game := self new.
        game run.
    ]

    run [
        running := true.
        location := #startCage.
        Transcript show: Descriptions title; cr.
        Transcript show: Descriptions instructions; cr.
        Transcript show: Descriptions introduction; cr.

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
                Transcript show: Descriptions instructions; cr.
            ].
        input = 'look'
            ifTrue: [
                Transcript show: (Descriptions locations at: location); cr.
            ].

        Transcript
            show: 'Unknown command.';
            cr.
    ]

]

LostPaws start.