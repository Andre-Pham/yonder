//
//  LifestealBasePill.swift
//  yonder
//
//  Created by Andre Pham on 13/7/2022.
//

import Foundation

class LifestealBasePill: WeaponBasePill, DamageSubscriber, HealthRestorationSubscriber {
    
    private(set) var damage: Int
    public let effectsDescription: String?
    
    init(damage: Int) {
        self.damage = damage
        self.effectsDescription = Strings.WeaponBasePill.Lifesteal.EffectsDescription.local
    }
    
    func setup(weapon: Weapon) {
        weapon.setDamage(to: self.damage)
        weapon.setHealthRestoration(to: self.damage)
        weapon.addDamageSubscriber(self)
    }
    
    func getValue() -> Int {
        return self.damage*2
    }
    
    func onDamageChange(_ item: ItemAbstract, old: Int) {
        item.setHealthRestoration(to: item.damage)
    }
    
    func onHealthRestorationChange(_ item: ItemAbstract, old: Int) {
        if item.healthRestoration != item.damage {
            item.setHealthRestoration(to: item.damage)
        }
    }
    
}
