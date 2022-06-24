//
//  Weapon.swift
//  yonder
//
//  Created by Andre Pham on 20/11/21.
//

import Foundation

class Weapon: ItemAbstract, Usable, Purchasable, Clonable, Enhanceable {
    
    private(set) var basePurchasePrice: Int = 0
    private let basePill: WeaponBasePill
    private let durabilityPill: WeaponDurabilityPill
    private(set) var effectPills: [WeaponEffectPill]
    var fullSummary: String {
        var summaryComponents = [String]()
        summaryComponents.append(self.name)
        if self.damage > 0 {
            summaryComponents.append(String(self.damage) + " " + Strings.Stat.Damage.local)
        }
        if self.healthRestoration > 0 {
            summaryComponents.append(String(self.healthRestoration) + " " + Strings.Stat.HealthRestoration.local)
        }
        if let effectsDescription = self.effectsDescription {
            summaryComponents.append(effectsDescription)
        }
        return summaryComponents.joined(separator: "\n")
    }
    
    init(name: String = "placeholderName", description: String = "placeholderDescription", basePill: WeaponBasePill, durabilityPill: WeaponDurabilityPill, effectPills: [WeaponEffectPill] = []) {
        self.basePill = basePill
        self.durabilityPill = durabilityPill
        self.effectPills = effectPills
        
        super.init(name: name, description: description, effectsDescription: Weapon.getEffectsDescription(durabilityPill: durabilityPill, effectPills: effectPills))
        
        self.basePill.setup(weapon: self)
        self.durabilityPill.setupDurability(weapon: self)
        self.basePurchasePrice = self.getCurrentPrice() // Needs setup to get current price
    }
    
    required init(_ original: Weapon) {
        self.basePill = original.basePill
        self.durabilityPill = original.durabilityPill
        self.effectPills = original.effectPills
        
        super.init(name: original.name, description: original.description, effectsDescription: original.effectsDescription)
        
        self.basePill.setup(weapon: self)
        self.durabilityPill.setupDurability(weapon: self)
        self.basePurchasePrice = original.basePurchasePrice
    }
    
    private static func getEffectsDescription(durabilityPill: WeaponDurabilityPill, effectPills: [WeaponEffectPill]) -> String {
        var effectsDescription = durabilityPill.effectsDescription
        for effectPill in effectPills {
            effectsDescription += "\n" + effectPill.effectsDescription
        }
        return effectsDescription
    }
    
    func addEffect(_ effect: WeaponEffectPill) {
        self.effectPills.append(effect)
        self.resetEffectsDescription(to: Weapon.getEffectsDescription(durabilityPill: self.durabilityPill, effectPills: self.effectPills))
    }
    
    func getCurrentPrice() -> Int {
        return self.remainingUses*(
            self.basePill.getValue() +
            self.durabilityPill.getValue() +
            self.effectPills.map { $0.getValue() }.reduce(0, +))
    }
    
    func use(owner: ActorAbstract, opposition: ActorAbstract) {
        if self.healthRestoration > 0 {
            owner.restoreHealthAdjusted(sourceOwner: owner, using: self, for: self.healthRestoration)
        }
        if self.damage > 0 {
            opposition.damageAdjusted(sourceOwner: owner, using: self, for: self.damage)
        }
        
        for pill in self.effectPills {
            pill.apply(owner: owner, opposition: opposition)
        }
        
        // Durability pill comes after, otherwise stuff like dulling pill wouldn't work as intended
        self.durabilityPill.use(on: self)
    }
    
    func getPurchaseInfo() -> PurchasableItemInfo {
        return PurchasableItemInfo(name: self.name, description: self.description, type: .weapon)
    }
    
    func beReceived(by receiver: Player, amount: Int) {
        for _ in 0..<amount {
            receiver.addWeapon(self.clone())
        }
    }
    
    func getEnhanceInfo() -> EnhanceInfo {
        return EnhanceInfo(id: self.id, name: self.name)
    }
    
}
