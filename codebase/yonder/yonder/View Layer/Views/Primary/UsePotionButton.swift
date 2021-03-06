//
//  UsePotionButton.swift
//  yonder
//
//  Created by Andre Pham on 21/2/2022.
//

import SwiftUI

struct UsePotionButton: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var potionViewModel: PotionViewModel
    @State private var useButtonActive = false
    
    var body: some View {
        YonderExpandableWideButtonBody(isExpanded: self.$useButtonActive) {
            VStack(alignment: .leading) {
                YonderText(text: self.potionViewModel.name, size: .buttonBody)
                    .padding(.bottom, YonderCoreGraphics.buttonTitleSpacing)
                
                if let effectsDescription = self.potionViewModel.effectsDescription {
                    if let foeViewModel = GameManager.instance.foeViewModel, self.potionViewModel.damage > 0 {
                            IndicativeEffectsDescriptionView(
                                effectsDescription: effectsDescription,
                                indicative: self.playerViewModel.getIndicativeDamage(itemViewModel: self.potionViewModel, opposition: foeViewModel),
                                size: .buttonBodySubscript)
                    } else if self.potionViewModel.healthRestoration > 0 {
                        IndicativeEffectsDescriptionView(
                            effectsDescription: effectsDescription,
                            indicative: self.playerViewModel.getIndicativeHealthRestoration(of: self.potionViewModel),
                            size: .buttonBodySubscript)
                    } else if self.potionViewModel.armorPointsRestoration > 0 {
                        IndicativeEffectsDescriptionView(
                            effectsDescription: effectsDescription,
                            indicative: self.playerViewModel.getIndicativeArmorPointsRestoration(of: self.potionViewModel),
                            size: .buttonBodySubscript)
                    } else {
                        YonderText(text: effectsDescription, size: .buttonBodySubscript)
                    }
                }
                
                YonderTextNumeralHStack {
                    YonderNumeral(number: self.potionViewModel.remainingUses, size: .buttonBodySubscript)
                    
                    YonderText(text: (self.potionViewModel.remainingUses == 1 ? Strings.Stat.Potion.RemainingUsesSingular.local : Strings.Stat.Potion.RemainingUses.local).leftPadded(by: " "), size: .buttonBodySubscript)
                }
            }
        } expandedContent: {
            YonderWideButton(text: Strings.Button.InstantUse.local) {
                self.playerViewModel.use(potionViewModel: self.potionViewModel)
            }
        }
    }
}

struct UsePotionButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            YonderColors.backgroundMaxDepth
                .ignoresSafeArea()
            
            UsePotionButton(
                playerViewModel: PreviewObjects.playerViewModel,
                potionViewModel: PreviewObjects.potionViewModel)
        }
    }
}
