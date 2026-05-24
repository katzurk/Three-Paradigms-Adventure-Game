Object subclass: Location [
    | name objects paths |

    Location class >> named: aName [
        ^ self new init: aName
    ]

    init: aName [
        name := aName.
        objects := OrderedCollection new.
        paths := Dictionary new.
    ]

    name [
        ^ name
    ]

    objects [
        ^ objects
    ]

    paths [
        ^ paths
    ]

    addObject: anObject [
        objects add: anObject.
    ]

    addPath: direction to: destination [
        paths at: direction put: destination.
    ]

    pathAt: direction [
        ^ paths at: direction ifAbsent: [ nil ]
    ]
]