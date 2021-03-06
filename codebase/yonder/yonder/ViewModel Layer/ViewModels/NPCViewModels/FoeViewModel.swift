//
//  FoeViewModel.swift
//  yonder
//
//  Created by Andre Pham on 8/2/2022.
//

import Foundation
import Combine

class FoeViewModel: ObservableObject {
    
    // foe can be used within the ViewModel layer, but Views should only interact with ViewModels (not the Model layer)
    private(set) var foe: Foe
    private var subscriptions: Set<AnyCancellable> = []
    
    private(set) var id: UUID
    private(set) var name: String
    private(set) var description: String
    @Published private(set) var health: Int
    @Published private(set) var maxHealth: Int
    @Published private(set) var isDead: Bool
    
    @Published private(set) var weaponViewModel: WeaponViewModel
    @Published private(set) var lootOptionsViewModel: LootOptionsViewModel
    
    init(_ foe: Foe) {
        self.foe = foe
        
        // Set properties to match Interactor
        
        self.id = self.foe.id
        self.name = self.foe.name
        self.description = self.foe.description
        self.health = self.foe.health
        self.maxHealth = self.foe.maxHealth
        self.isDead = self.foe.isDead
        
        // Set other view models
        
        self.weaponViewModel = WeaponViewModel(self.foe.getWeapon())
        self.lootOptionsViewModel = LootOptionsViewModel(self.foe.loot)
        
        // Add Subscribers
        
        self.foe.$health.sink(receiveValue: { newValue in
            self.health = newValue
            self.isDead = self.foe.isDead
        }).store(in: &self.subscriptions)
        
        self.foe.$maxHealth.sink(receiveValue: { newValue in
            self.maxHealth = newValue
        }).store(in: &self.subscriptions)
        
    }
    
    func getIndicativeDamage() -> Int {
        return self.foe.getIndicativeDamage(of: self.foe.getWeapon(), opposition: GameManager.instance.playerVM.player)
    }
    
}
