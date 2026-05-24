Object subclass: GameObject [
    | name contains |
    
    GameObject class >> named: aName [
        ^ self new init: aName
    ]

    init: aName [
        name := aName.
        contains := OrderedCollection new.
    ]

    name [
        ^ name
    ]

    contains [
        ^ contains
    ]

    empty [
        contains := OrderedCollection new.
    ]

    addObject: anObject [
        contains add: anObject.
    ]

    isFood [
        ^ false
    ]

    hungerValue [
        ^ 0
    ]

    onEatBy: game [
        game printText: 'You cannot eat that.'.
        ^ false
    ]
]

GameObject subclass: Food [
    isFood [
        ^ true
    ]

    onEatBy: game [
        game decreaseHunger: self hungerValue.
        game removeFromMouth: self.
    ]
]

Food subclass: Fish [
    hungerValue [
        ^ 3
    ]

    onEatBy: game [
        game decreaseHunger: self hungerValue.
        game printText: (Descriptions eatDescriptions at: #fish).
        game removeFromMouth: self.
    ]
]

Food subclass: Rodent [
    hungerValue [
        ^ 2
    ]

    onEatBy: game [
        game decreaseHunger: self hungerValue.
        game printText: (Descriptions eatDescriptions at: #rodent).
        game removeFromMouth: self.
    ]
]

Food subclass: Poison [
    onEatBy: game [
        game printText: (Descriptions eatDescriptions at: (self name)).
        game loseGame.
    ]
]
