//
//  UseWeaponButton.swift
//  yonder
//
//  Created by Andre Pham on 21/2/2022.
//

import SwiftUI

struct UseWeaponButton: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var weaponViewModel: WeaponViewModel
    @State private var useButtonActive = false
    
    var body: some View {
        YonderExpandableWideButtonBody(isExpanded: self.$useButtonActive) {
            VStack(alignment: .leading) {
                YonderText(text: self.weaponViewModel.name, size: .buttonBody)
                    .padding(.bottom, YonderCoreGraphics.buttonTitleSpacing)
                
                if self.weaponViewModel.damage > 0 {
                    YonderTextNumeralHStack {
                        if let foeViewModel = GameManager.instance.foeViewModel {
                            IndicativeNumeralView(
                                original: self.weaponViewModel.damage,
                                indicative: self.playerViewModel.getIndicativeDamage(itemViewModel: self.weaponViewModel, opposition: foeViewModel),
                                size: .buttonBodySubscript)
                        } else {
                            YonderNumeral(number: self.weaponViewModel.damage, size: .buttonBodySubscript)
                        }
                        
                        YonderText(text: Strings.Stat.Damage.local.leftPadded(by: " "), size: .buttonBodySubscript)
                    }
                }
                
                if self.weaponViewModel.healthRestoration > 0 {
                    YonderTextNumeralHStack {
                        IndicativeNumeralView(
                            original: self.weaponViewModel.healthRestoration,
                            indicative: self.playerViewModel.getIndicativeHealthRestoration(of: self.weaponViewModel),
                            size: .buttonBodySubscript)
                        
                        YonderText(text: Strings.Stat.HealthRestoration.local.leftPadded(by: " "), size: .buttonBodySubscript)
                    }
                }
                
                if self.weaponViewModel.armorPointsRestoration > 0 {
                    YonderTextNumeralHStack {
                        IndicativeNumeralView(
                            original: self.weaponViewModel.armorPointsRestoration,
                            indicative: self.playerViewModel.getIndicativeArmorPointsRestoration(of: self.weaponViewModel),
                            size: .buttonBodySubscript)
                        
                        YonderText(text: Strings.Stat.ArmorPointsRestoration.local.leftPadded(by: " "), size: .buttonBodySubscript)
                    }
                }
                
                if let effectsDescription = self.weaponViewModel.previewEffectsDescription {
                    YonderText(text: effectsDescription, size: .buttonBodySubscript)
                }
                
                YonderTextNumeralHStack {
                    if self.weaponViewModel.infiniteRemainingUses {
                        YonderText(text: Strings.Item.Infinite.local, size: .buttonBodySubscript)
                    } else {
                        YonderNumeral(number: self.weaponViewModel.remainingUses, size: .buttonBodySubscript)
                    }
                    
                    YonderText(text: (self.weaponViewModel.remainingUses == 1 ? Strings.Stat.Weapon.RemainingUsesSingular.local : Strings.Stat.Weapon.RemainingUses.local).leftPadded(by: " "), size: .buttonBodySubscript)
                }
            }
        } expandedContent: {
            YonderWideButton(text: Strings.Button.Use.local) {
                self.playerViewModel.use(weaponViewModel: self.weaponViewModel)
            }
        }
    }
}

struct UseWeaponButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            YonderColors.backgroundMaxDepth
                .ignoresSafeArea()
            
            UseWeaponButton(
                playerViewModel: PreviewObjects.playerViewModel,
                weaponViewModel: PreviewObjects.weaponViewModel)
        }
    }
}
