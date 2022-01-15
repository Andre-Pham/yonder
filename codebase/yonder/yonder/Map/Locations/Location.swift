//
//  Location.swift
//  yonder
//
//  Created by Andre Pham on 20/11/21.
//

import Foundation

typealias LocationAbstract = LocationAbstractPart & LocationTyped

protocol LocationTyped {
    
    var type: LocationType { get }
    
}

class LocationAbstractPart {
    
    private(set) var nextLocations = [LocationAbstract]()
    private(set) var bridgeLocation: BridgeLocation?
    private(set) var bridgeAccessibility: LocationBridgeAccessibility
    private(set) var hexagonCoordinate: HexagonCoordinate?
    private(set) var areaContent = AreaContentContainer()
    public let id = UUID()
    
    init() {
        self.bridgeAccessibility = .noBridge
        self.hexagonCoordinate = nil
    }
    
    func addNextLocations(_ locations: [LocationAbstract]) {
        self.nextLocations.append(contentsOf: locations)
    }
    
    func setBridgeLocation(_ bridgeLocation: BridgeLocation) {
        self.bridgeLocation = bridgeLocation
    }
    
    func setBridgeAccessibility(_ bridgeAccessibility: LocationBridgeAccessibility) {
        if self.bridgeAccessibility != .noBridge {
            YonderDebugging.printError(message: "Bridge accessbility has been set more than once, which shouldn't be occuring", functionName: #function, className: "\(type(of: self))")
        }
        self.bridgeAccessibility = bridgeAccessibility
    }
    
    func setHexagonCoordinate(_ x: Int, _ y: Int) {
        if self.hexagonCoordinate != nil {
            YonderDebugging.printError(message: "Hexagon coordinate has been set more than once, which shouldn't be occuring - set from (\(String(describing: self.hexagonCoordinate?.x)), \(String(describing: self.hexagonCoordinate?.y))) to (\(x), \(y))", functionName: #function, className: "\(type(of: self))")
        }
        self.hexagonCoordinate = HexagonCoordinate(x, y)
    }
    
    func setAreaContent(_ area: Area) {
        self.areaContent.setContent(name: area.name, description: area.description, image: area.image)
    }
    
}
