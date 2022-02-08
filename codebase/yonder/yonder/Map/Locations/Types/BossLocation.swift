//
//  BossLocation.swift
//  yonder
//
//  Created by Andre Pham on 24/12/21.
//

import Foundation

class BossLocation: LocationAbstract, FoeLocation {
    
    private(set) var foe: FoeAbstract
    public let type: LocationType = .boss
    
    init(boss: FoeAbstract) {
        self.foe = boss
    }
    
}
