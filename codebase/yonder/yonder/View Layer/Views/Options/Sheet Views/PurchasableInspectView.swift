//
//  PurchasableInspectView.swift
//  yonder
//
//  Created by Andre Pham on 2/4/2022.
//

import SwiftUI

struct PurchasableInspectView: View {
    @ObservedObject var purchasableViewModel: PurchasableViewModel
    
    var body: some View {
        if let itemViewModel = self.purchasableViewModel.getItemViewModel() {
            ItemInspectView(itemViewModel: itemViewModel)
        }
        else {
            let (name, description) = self.purchasableViewModel.getNameAndDescription()
            DefaultInspectView(name: name, description: description)
        }
    }
}
