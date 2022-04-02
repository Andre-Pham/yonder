//
//  PurchaseFromShopkeeperButton.swift
//  yonder
//
//  Created by Andre Pham on 20/3/2022.
//

import SwiftUI

struct PurchaseFromShopKeeperButton: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var purchasableViewModel: PurchasableViewModel
    var pageGeometry: GeometryProxy
    @State private var useButtonActive = false
    @State private var infoSheetActive = false
    private let amount = 1
    
    // TODO: - This entire button really needs a rework, but i'm not really sure how to implement layered buttons without using this approach
    var body: some View {
        ZStack(alignment: .bottom) {
            YonderWideButtonBody {
                self.useButtonActive.toggle()
            } label: {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            YonderText(text: self.purchasableViewModel.name, size: .buttonBody)
                            
                            YonderTextAndNumeral(format: [.text, .numeral], text: ["Remaining stock: "], numbers: [self.purchasableViewModel.stockRemaining], size: .buttonBodySubscript)
                            
                            HStack {
                                YonderWideButton(text: "Info", verticalPadding: YonderCoreGraphics.padding, action: {})
                                    .hidden()
                                
                                YonderIconNumeralPair(image: YonderImages.goldIcon, numeral: self.purchasableViewModel.price, size: .buttonBody, animationIsActive: false)
                                    .padding(.horizontal, YonderCoreGraphics.padding*1.5)
                                    .padding(.vertical, YonderCoreGraphics.padding)
                                    .border(Color.Yonder.border, width: YonderCoreGraphics.borderWidth)
                            }
                        }
                    }
                    .padding(.horizontal, YonderCoreGraphics.padding)
                    
                    if self.useButtonActive {
                        // Expand button frame
                        YonderWideButton(text: "") {}
                        .padding(.top, YonderCoreGraphics.padding)
                        .hidden()
                    }
                }
            }
            
            VStack {
                HStack {
                    YonderWideButton(text: "Info", verticalPadding: YonderCoreGraphics.padding) {
                        self.infoSheetActive.toggle()
                    }
                    .withInspectSheet(
                        isPresented: self.$infoSheetActive,
                        pageGeometry: pageGeometry,
                        content: AnyView(
                            PurchasableInspectView(purchasableViewModel: self.purchasableViewModel)
                    ))
                    
                    YonderIconNumeralPair(image: YonderImages.goldIcon, numeral: self.purchasableViewModel.price, size: .buttonBody, animationIsActive: false)
                        .padding(.horizontal, YonderCoreGraphics.padding*1.5)
                        .padding(.vertical, YonderCoreGraphics.padding)
                        .border(Color.Yonder.border, width: YonderCoreGraphics.borderWidth)
                        .hidden()
                }
                .padding(.horizontal, YonderCoreGraphics.padding)
                .padding(.bottom, YonderCoreGraphics.padding + YonderCoreGraphics.borderWidth/2)
                
                if self.useButtonActive {
                    // Expand button frame
                    YonderWideButton(text: "") {}
                    .padding(.top, YonderCoreGraphics.padding)
                    .hidden()
                }
            }
            
            if self.useButtonActive {
                YonderWideButton(text: Term.purchase.capitalized) {
                    self.purchasableViewModel.purchase(by: self.playerViewModel, amount: self.amount)
                }
                .padding(.horizontal, YonderCoreGraphics.padding)
                .padding(.bottom, YonderCoreGraphics.padding)
                .disabled(self.purchasableViewModel.purchaseIsDisabled(for: self.playerViewModel, amount: self.amount))
                .opacity(self.purchasableViewModel.purchaseIsDisabled(for: self.playerViewModel, amount: self.amount) ? YonderCoreGraphics.disabledButtonOpacity : 1)
            }
        }
    }
}