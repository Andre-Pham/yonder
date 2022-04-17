//
//  ViewEnhanceablesButton.swift
//  yonder
//
//  Created by Andre Pham on 11/4/2022.
//

import SwiftUI

struct ViewEnhanceablesButton: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var enhanceOfferViewModel: EnhanceOfferViewModel
    let pageGeometry: GeometryProxy
    @ObservedObject var purchaseEnhanceOfferStateManager: PurchaseEnhanceOfferStateManager
    @State private var viewButtonActive = false
    @State private var optionsSheetActive = false
    @StateObject private var popupStateManager = PopupStateManager()
    
    var isDisabled: Bool {
        return !self.enhanceOfferViewModel.canBeAfforded(by: self.playerViewModel) || enhanceOfferViewModel.getEnhanceableInfos(playerViewModel: self.playerViewModel).isEmpty
    }
    
    init(playerViewModel: PlayerViewModel, enhanceOfferViewModel: EnhanceOfferViewModel, pageGeometry: GeometryProxy) {
        self.playerViewModel = playerViewModel
        self.enhanceOfferViewModel = enhanceOfferViewModel
        self.pageGeometry = pageGeometry
        self.purchaseEnhanceOfferStateManager = PurchaseEnhanceOfferStateManager(offerCount: enhanceOfferViewModel.getEnhanceableInfos(playerViewModel: playerViewModel).count)
    }
    
    var body: some View {
        YonderExpandableWideButtonBody(isExpanded: self.$viewButtonActive) {
            VStack(alignment: .leading) {
                YonderText(text: self.enhanceOfferViewModel.name, size: .buttonBody)
                
                YonderText(text: self.enhanceOfferViewModel.description, size: .buttonBodySubscript)
            }
        } expandedContent: {
            YonderWideButton(text: "View Options") {
                self.optionsSheetActive = true
            }
            .disabledWhen(self.isDisabled)
        }
        .sheet(isPresented: self.$optionsSheetActive) {
            InspectSheet(pageGeometry: self.pageGeometry) {
                VStack {
                    ForEach(Array(zip(enhanceOfferViewModel.getEnhanceableInfos(playerViewModel: self.playerViewModel).indices, enhanceOfferViewModel.getEnhanceableInfos(playerViewModel: self.playerViewModel))), id: \.1.id) { index, enhanceInfoViewModel in
                        
                        YonderExpandableWideButtonBody(isExpanded: self.$purchaseEnhanceOfferStateManager.purchaseButtonActiveBindings[index]) {
                            YonderText(text: enhanceInfoViewModel.name, size: .buttonBody)
                        } expandedContent: {
                            YonderWideButton(text: Term.purchase.capitalized) {
                                self.enhanceOfferViewModel.accept(playerViewModel: self.playerViewModel, enhanceableID: enhanceInfoViewModel.id)
                                self.popupStateManager.activatePopup()
                            }
                            .disabledWhen(self.isDisabled)
                        }
                    }
                }
            }
            .onTapGesture {
                self.optionsSheetActive = false
            }
            .withFeedbackPopup(text: Term.enhanced.capitalized, padding: YonderCoreGraphics.padding*3, popupStateManager: self.popupStateManager)
        }
    }
}

struct ViewEnhanceablesButton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Color.Yonder.backgroundMaxDepth
                    .ignoresSafeArea()
                
                ViewEnhanceablesButton(
                    playerViewModel: PlayerViewModel(
                        Player(
                            maxHealth: 200,
                            location: NoLocation()
                        )
                    ),
                    enhanceOfferViewModel:
                        EnhanceOfferViewModel(
                            ArmorPointsEnhanceOffer(
                                price: 100,
                                armorPoints: 200)
                        ),
                    pageGeometry: geo
                )
            }
        }
    }
}
