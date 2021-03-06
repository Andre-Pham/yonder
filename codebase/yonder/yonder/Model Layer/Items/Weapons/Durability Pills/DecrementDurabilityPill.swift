//
//  DecrementDurabilityPill.swift
//  yonder
//
//  Created by Andre Pham on 23/6/2022.
//

import Foundation

class DecrementDurabilityPill: WeaponDurabilityPill {
    
    public let effectsDescription: String
    public let decrementation: Int
    private let durability: Int
    
    init(durability: Int, decrementBy amount: Int = 1) {
        self.durability = durability
        self.effectsDescription = Strings.WeaponDurabilityPill.Decrement.Description1Param.localWithArgs(amount)
        self.decrementation = -amount
    }
    
    func setupDurability(weapon: Weapon) {
        weapon.setRemainingUses(to: self.durability)
        weapon.setInfiniteRemainingUses(to: false)
    }
    
    func use(on weapon: Weapon) {
        weapon.adjustRemainingUses(by: self.decrementation)
    }
    
    func getValue() -> Int {
        return 0
    }
    
}
