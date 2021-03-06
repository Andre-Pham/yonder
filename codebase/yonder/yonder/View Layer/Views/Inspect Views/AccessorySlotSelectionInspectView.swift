//
//  AccessorySlotSelectionInspectView.swift
//  yonder
//
//  Created by Andre Pham on 9/7/2022.
//

import SwiftUI

struct AccessorySlotSelectionInspectView: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    let onSelection: (_ selection: UUID?) -> Void
    
    var body: some View {
        InspectBody {
            YonderText(text: Strings.Inspect.AccessorySlotSelection.Title.local, size: .inspectSheetTitle)
            
            YonderText(text: Strings.Inspect.AccessorySlotSelection.Description.local, size: .inspectSheetBody)
            
            InspectSectionSpacingView()
            
            VStack {
                SurroundingBrackets(bracket: "[", size: .title4) {
                    YonderText(text: Strings.Inspect.AccessorySlotSelection.Header.local, size: .title4)
                }
                .frame(maxWidth: .infinity)
                
                ForEach(self.playerViewModel.accessoryViewModels, id: \.id) { accessoryViewModel in
                    YonderWideButton(text: accessoryViewModel.name) {
                        onSelection(accessoryViewModel.id)
                        dismiss()
                    }
                }
                
                if !self.playerViewModel.accessorySlotsFull {
                    YonderWideButtonBody {
                        onSelection(nil)
                        dismiss()
                    } label: {
                        SurroundingBrackets(bracket: "[", size: .buttonBody) {
                            YonderText(text: Strings.Button.InsertToEmptySlot.local, size: .buttonBody)
                        }
                    }
                }
            }
        }
    }
}

struct AccessorySlotSelectionInspectView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            YonderColors.backgroundMaxDepth
                .ignoresSafeArea()
            
            AccessorySlotSelectionInspectView(playerViewModel: PreviewObjects.playerViewModel) { selection in
                print(selection?.uuidString ?? "nil")
            }
        }
    }
}
