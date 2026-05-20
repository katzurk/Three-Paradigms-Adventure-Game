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

    addObject: anObject [
        contains add: anObject.
    ]
]