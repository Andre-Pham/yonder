//
//  TavernArea.swift
//  yonder
//
//  Created by Andre Pham on 21/11/21.
//

import Foundation

class TavernArea {
    
    private(set) var rootLocations = [LocationAbstract]()
    private(set) var tipLocations = [LocationAbstract]()
    public let arrangement: TavernAreaArrangements
    public let locations: [LocationAbstract]
    
    init(restorer: RestorerLocation, potionShop: ShopLocation, enhancer: EnhancerLocation) {
        self.arrangement = .S
        self.locations = [restorer, potionShop, enhancer]
        self.generateAreaArrangement()
    }
    
    init(restorer: RestorerLocation, potionShop: ShopLocation, enhancer: EnhancerLocation, weaponShop: ShopLocation) {
        self.arrangement = .M
        self.locations = [restorer, potionShop, enhancer, weaponShop]
        self.generateAreaArrangement()
    }
    
    init(restorer: RestorerLocation, potionShop: ShopLocation, enhancer: EnhancerLocation, weaponShop: ShopLocation, friendy: FriendlyLocation) {
        self.arrangement = .L
        self.locations = [restorer, potionShop, enhancer, weaponShop, friendy]
        self.generateAreaArrangement()
    }
    
    init(restorer: RestorerLocation, potionShop: ShopLocation, enhancer: EnhancerLocation, weaponShop: ShopLocation, friendy: FriendlyLocation, secondFriendly: FriendlyLocation) {
        self.arrangement = .XL
        self.locations = [restorer, potionShop, enhancer, weaponShop, friendy, secondFriendly]
        self.generateAreaArrangement()
    }
    
    func addRootLocations(_ locations: [LocationAbstract]) {
        self.rootLocations.append(contentsOf: locations)
    }
    
    func addRootLocations(_ locationIndices: Int...) {
        let locations = locationIndices.map { self.locations[$0] }
        self.addRootLocations(locations)
    }
    
    func addTipLocations(_ locations: [LocationAbstract]) {
        self.tipLocations.append(contentsOf: locations)
    }
    
    func addTipLocations(_ locationIndices: Int...) {
        let locations = locationIndices.map { self.locations[$0] }
        self.addTipLocations(locations)
    }
    
    func addNextLocations(from location: LocationAbstract, to nextLocations: [LocationAbstract]) {
        location.addNextLocations(nextLocations)
    }
    
    func addNextLocations(from locationIndex: Int, to nextLocationIndices: Int...) {
        let location = self.locations[locationIndex]
        let nextLocations = nextLocationIndices.map { self.locations[$0] }
        self.addNextLocations(from: location, to: nextLocations)
    }
    
    func createUndirectedEdge(between location: LocationAbstract, and otherLocation: LocationAbstract) {
        location.addNextLocations([otherLocation])
        otherLocation.addNextLocations([location])
    }
    
    func createUndirectedEdge(between locationIndex: Int, and otherLocationIndex: Int) {
        let location = self.locations[locationIndex]
        let otherLocation = self.locations[otherLocationIndex]
        self.createUndirectedEdge(between: location, and: otherLocation)
    }

}
