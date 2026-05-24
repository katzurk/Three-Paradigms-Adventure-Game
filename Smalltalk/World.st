FileStream fileIn: 'GameObject.st'.
FileStream fileIn: 'Location.st'.

Object subclass: World [
    | locations |
    World class >> build [
        | world |
        world := self new.
        world init.
        ^ world
    ]

    init [

        | startCage forest lowForest infiniteForest 
        road rockyRoad meadow car river waterfall barn town 
        wheatField cabbageField bridge graveyard home
        box cage branch rock hat hay brick fish rodents special shelter|

        locations := Dictionary new.

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
        shelter := Location named: #shelter.
        
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
        rockyRoad addPath: #s to: #shelter.

        meadow addPath: #n to: #startCage.
        meadow addPath: #w to: #rockyRoad.
        meadow addPath: #e to: #infiniteForest.
        meadow addPath: #s to: #shelter.

        waterfall addPath: #e to: #road.
        waterfall addPath: #s to: #river.

        river addPath: #n to: #waterfall.
        river addPath: #e to: #rockyRoad.
        river addPath: #s to: #shelter.

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
        cage addObject: (Rodent named: #hamster).
        startCage addObject: (cage).

        box := GameObject named: #cardboardBox.
        box addObject: (Fish named: #cod).
        box addObject: (Fish named: #mackerel).
        box addObject: (Fish named: #roach).
        forest addObject: (box).
        forest addObject: (GameObject named: #bigStick).

        branch := GameObject named: #branch.
        branch addObject: (Rodent named: #squirrel).
        lowForest addObject: (branch).
        lowForest addObject: (GameObject named: #smallStick).

        road addObject: (GameObject named: #brokenStool).
        road addObject: (Poison named: #chocolate).
        road addObject: (HeavyObject named: #sofa).


        rock := GameObject named: #whiteRock.
        hat := GameObject named: #hat.
        hat addObject: (Rodent named: #gerbil).
        rock addObject: hat.
        meadow addObject: (rock).
        
        hay := GameObject named: #hay.
        hay addObject: (Rodent named: #brownMouse).
        wheatField addObject: (hay).

        brick := GameObject named: #brick.
        brick addObject: (Rodent named: #tinyMouse).
        barn addObject: (Poison named: #catnip).
        barn addObject: (brick).

        graveyard addObject: (GameObject named: #bone).

        town addObject: (HeavyObject named: #dog).
        town addObject: (Rodent named: #rat).

        locations at: #startCage put: startCage.
        locations at: #forest put: forest.
        locations at: #lowForest put: lowForest.
        locations at: #infiniteForest put: infiniteForest.
        locations at: #road put: road.
        locations at: #rockyRoad put: rockyRoad.
        locations at: #meadow put: meadow.
        locations at: #car put: car.
        locations at: #river put: river.
        locations at: #waterfall put: waterfall.
        locations at: #barn put: barn.
        locations at: #town put: town.
        locations at: #wheatField put: wheatField.
        locations at: #cabbageField put: cabbageField.
        locations at: #bridge put: bridge.
        locations at: #graveyard put: graveyard.
        locations at: #home put: home.
        locations at: #shelter put: shelter.
        
        ^ locations.
    ]

    at: key [
        ^ locations at: key
    ]

]


