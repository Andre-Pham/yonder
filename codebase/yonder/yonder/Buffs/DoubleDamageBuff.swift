//
//  DoubleDamageBuff.swift
//  yonder
//
//  Created by Andre Pham on 18/11/21.
//

import Foundation

class DoubleDamageBuff: BuffAbstract {
    
    init(duration: Int) {
        super.init(duration: duration, type: .damage)
    }
    
    override func applyToDamage(damage: Int) -> Int? {
        return damage*2
    }
    
}