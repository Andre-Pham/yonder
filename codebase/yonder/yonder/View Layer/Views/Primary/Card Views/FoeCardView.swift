//
//  FoeCardView.swift
//  yonder
//
//  Created by Andre Pham on 10/12/21.
//

import SwiftUI

struct FoeCardView: View {
    @ObservedObject var foeViewModel: FoeViewModel
    
    var body: some View {
        CardBody(name: foeViewModel.name) {
            CardInteractorTypeView()
            
            CardRowView(
                value: self.foeViewModel.weaponViewModel.damage,
                indicativeValue: self.foeViewModel.getIndicativeDamage(),
                image: YonderImages.foeDamageIcon)
            
            CardRowView(
                value: self.foeViewModel.health,
                maxValue: self.foeViewModel.maxHealth,
                image: YonderImages.healthIcon)
        }
    }
}

struct EnemyCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            YonderColors.backgroundMaxDepth
                .ignoresSafeArea()
            
            FoeCardView(foeViewModel: PreviewObjects.foeViewModel)
        }
    }
}
