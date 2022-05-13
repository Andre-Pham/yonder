//
//  EnhancerInspectView.swift
//  yonder
//
//  Created by Andre Pham on 9/5/2022.
//

import SwiftUI

struct EnhancerInspectView: View {
    @ObservedObject var enhancerViewModel: EnhancerViewModel
    
    var body: some View {
        InspectNPCBody(
            name: self.enhancerViewModel.name,
            description: self.enhancerViewModel.description,
            locationType: LocationType.enhancer
        ) {
            YonderText(text: "Offers", size: .inspectSheetTitle)
            
            ForEach(self.enhancerViewModel.enhanceOfferViewModels, id: \.id) { offer in
                YonderText(text: "[\(offer.name)]\n\(offer.description)", size: .inspectSheetBody)
            }
        }
    }
}

struct EnhancerInspectView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.Yonder.backgroundMaxDepth
                .ignoresSafeArea()
            
            EnhancerInspectView(enhancerViewModel: EnhancerViewModel(Enhancer(
                name: "Ana",
                description: "You're powered up, get in there!",
                offers: [WeaponDamageEnhanceOffer(price: 100, damage: 200)])))
        }
    }
}
