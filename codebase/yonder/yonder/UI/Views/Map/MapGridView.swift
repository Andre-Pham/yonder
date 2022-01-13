//
//  MapGridView.swift
//  yonder
//
//  Created by Andre Pham on 2/1/2022.
//

import Foundation
import SwiftUI

// There is a lot of questionable maths in this... but it works, so just treat it like a blackbox with columns, spacing and height as parameters
struct MapGridView: View {
    
    let columnsCount: Int = 6
    let spacing: CGFloat = 10
    let hexagonFrameHeight: CGFloat = 150
    
    let maxLocationHeight: Int = 50 // TEMP
    let hexagonCount: Int
    let hexagonFrameWidth: CGFloat
    let hexagonWidth: CGFloat
    
    @ObservedObject private var mapViewModel: MapViewModel
    let locationConnections: [LocationConnection?]
    
    init(map: Map = GAME.map) {
        self.hexagonCount = maxLocationHeight*columnsCount
        self.hexagonFrameWidth = MathConstants.hexagonWidthToHeight*(self.hexagonFrameHeight + 2*self.spacing/tan((120.0 - 90.0)*MathConstants.degreesToRadians)) // I don't remember how I got this so just accept it's magic
        self.hexagonWidth = self.hexagonFrameWidth/2 * cos(.pi/6) * 2
        
        self.mapViewModel = MapViewModel(map)
        self.locationConnections = LocationConnectionGenerator(map: map, hexagonCount: self.hexagonCount, columnsCount: self.columnsCount).getAllLocationConnections()
    }
    
    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: spacing), count: columnsCount)
        
        ScrollView([.vertical, .horizontal]) {
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<hexagonCount, id: \.self) { index in
                    ZStack {
                        Hexagon()
                            .fill(.gray)
                            .onTapGesture {
                                print(index)
                            }
                            //.overlay(Text("\(index), \(locationConnections.last?.locationHexagonIndex ?? 3333)").foregroundColor(.white))
                            .frame(width: hexagonFrameWidth, height: hexagonFrameHeight/2)
                            .offset(x: isEvenRow(index) ? -(hexagonWidth/4 + spacing/4) : hexagonWidth/4 + spacing/4)
                            .frame(width: (hexagonFrameHeight*MathConstants.hexagonWidthToHeight)/2 + spacing, height: hexagonFrameHeight*0.216) // 0.216 was found from trial and error so don't think too hard about it
                            .reverseScroll()
                        
                        if let locationConnection = locationConnections[index] {
                            Hexagon()
                                .fill(.blue)
                                .frame(width: hexagonFrameWidth/2, height: hexagonFrameHeight/4)
                                .offset(x: isEvenRow(index) ? -(hexagonWidth/4 + spacing/4) : hexagonWidth/4 + spacing/4)
                                .frame(width: hexagonWidth/2, height: hexagonFrameHeight*0.25/2)
                                .reverseScroll()
                            
                            ForEach(locationConnection.previousLocationsHexagonCoordinates) { coords in
                                let values = getCoordinatesDifference(from: locationConnection.locationHexagonCoordinate, to: coords)
                                
                                GridConnectionView(down: values.1, downAcross: values.0, spacing: spacing, horizontalOffset: (hexagonWidth/4 + spacing/4)*(isEvenRow(index) ? -1 : 1))
                            }
                        }
                    }
                }
            }
            .frame(width: (hexagonWidth + spacing)*CGFloat(columnsCount) + spacing*6)
        }
        .padding(1) // Stops jittering
        .reverseScroll()
    }
    
    func isEvenRow(_ index: Int) -> Bool {
        return index/columnsCount % 2 == 0
    }
    
    func getCoordinatesDifference(from coordinates: HexagonCoordinate, to otherCoordinates: HexagonCoordinate) -> (Int, Int) {
        return (otherCoordinates.x - coordinates.x, abs(otherCoordinates.y - coordinates.y))
    }
    
}
