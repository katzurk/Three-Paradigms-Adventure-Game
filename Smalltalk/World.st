FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.

Object subclass: World [
    World class >> build [

        | world startCage forest lowForest infiniteForest 
        road rockyRoad meadow car river waterfall barn town 
        wheatField cabbageField bridge graveyard home
        box cage branch rock hat hay brick fish rodents special|

        world := Dictionary new.

        "All locations"
        startCage := Location named: #startCage.
        forest := Location named: #forest.
        lowForest := Location named: #lowForest.
        infiniteForest := Location named: #infiniteForest.
        road := Location named: #road.
        rockyRoad := Location named: #rockyRoad.
        meadow := Location named: #meadow.
        car := Location named: #car.
        river := Location named: #river.
        waterfall := Location named: #waterfall.
        barn := Location named: #barn.
        town := Location named: #town.
        wheatField := Location named: #wheatField.
        cabbageField := Location named: #cabbageField.
        bridge := Location named: #bridge.
        graveyard := Location named: #graveyard.
        home := Location named: #home.
        
        "Paths"
        startCage addPath: #n to: #forest.
        startCage addPath: #w to: #road.
        startCage addPath: #e to: #lowForest.
        startCage addPath: #s to: #meadow.

        forest addPath: #n to: #lake.
        forest addPath: #w to: #barn.
        forest addPath: #e to: #infiniteForest.
        forest addPath: #s to: #startCage.

        lowForest addPath: #n to: #infiniteForest.
        lowForest addPath: #w to: #startCage.
        lowForest addPath: #e to: #infiniteForest.
    
        infiniteForest addPath: #n to: #infiniteForest.
        infiniteForest addPath: #w to: #infiniteForest.
        infiniteForest addPath: #e to: #infiniteForest.
        infiniteForest addPath: #s to: #infiniteForest.
        
        road addPath: #n to: #barn.
        road addPath: #w to: #waterfall.
        road addPath: #e to: #startCage.
        road addPath: #s to: #rockyRoad.

        rockyRoad addPath: #n to: #road.
        rockyRoad addPath: #w to: #river.
        rockyRoad addPath: #e to: #meadow.

        meadow addPath: #n to: #startCage.
        meadow addPath: #w to: #rockyRoad.
        meadow addPath: #e to: #infiniteForest.

        waterfall addPath: #e to: #road.
        waterfall addPath: #s to: #river.

        river addPath: #n to: #waterfall.
        river addPath: #e to: #rockyRoad.

        wheatField addPath: #w to: #cabbageField.
        wheatField addPath: #s to: #barn.

        cabbageField addPath: #w to: #bridge.
        cabbageField addPath: #e to: #wheatField.
        cabbageField addPath: #s to: #car.

        bridge addPath: #w to: #town.
        bridge addPath: #e to: #wheatField.

        barn addPath: #n to: #wheatField.
        barn addPath: #w to: #car.
        barn addPath: #e to: #forest.
        barn addPath: #s to: #road.

        graveyard addPath: #e to: #town.

        town addPath: #w to: #graveyard.
        town addPath: #e to: #bridge.
        town addPath: #s to: #home.

        "Objects"
        cage := GameObject named: #cage.
        cage addObject: (GameObject named: #hamster).
        startCage addObject: (cage).

        box := GameObject named: #cardboardBox.
        box addObject: (GameObject named: #cod).
        box addObject: (GameObject named: #mackerel).
        box addObject: (GameObject named: #roach).
        forest addObject: (box).
        forest addObject: (GameObject named: #bigStick).

        branch := GameObject named: #branch.
        branch addObject: (GameObject named: #squirrel).
        lowForest addObject: (branch).
        lowForest addObject: (GameObject named: #smallStick).

        road addObject: (GameObject named: #brokenStool).
        road addObject: (GameObject named: #chocolate).
        road addObject: (GameObject named: #sofa).


        rock := GameObject named: #whiteRock.
        hat := GameObject named: #hat.
        hat addObject: (GameObject named: #gerbil).
        rock addObject: hat.
        meadow addObject: (hat).
        
        hay := GameObject named: #hay.
        hay addObject: (GameObject named: #brownMouse).
        wheatField addObject: (hay).

        brick := GameObject named: #brick.
        brick addObject: (GameObject named: #tinyMouse).
        barn addObject: (GameObject named: #catnip).
        barn addObject: (brick).

        graveyard addObject: (GameObject named: #bone).

        town addObject: (GameObject named: #dog).
        town addObject: (GameObject named: #rat).

        world at: #startCage put: startCage.
        world at: #forest put: forest.
        world at: #lowForest put: lowForest.
        world at: #infiniteForest put: infiniteForest.
        world at: #road put: road.
        world at: #rockyRoad put: rockyRoad.
        world at: #meadow put: meadow.
        world at: #car put: car.
        world at: #river put: river.
        world at: #waterfall put: waterfall.
        world at: #barn put: barn.
        world at: #town put: town.
        world at: #wheatField put: wheatField.
        world at: #cabbageField put: cabbageField.
        world at: #bridge put: bridge.
        world at: #graveyard put: graveyard.
        world at: #home put: home.
        
            
        ^ world.
    ]

    World class >> fish [
        ^ #(#cod #mackerel #roach #herring).
    ]

    World class >> rodents [
         ^ #(#hamster #brownMouse #tinyMouse #rat #squirrel #gerbil).
    ]

    World class >> special [
         ^ #(#chocolate #catnip).
    ]
]


