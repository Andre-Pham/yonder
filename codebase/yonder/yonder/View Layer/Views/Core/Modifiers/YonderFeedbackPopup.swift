//
//  YonderFeedbackPopup.swift
//  yonder
//
//  Created by Andre Pham on 15/4/2022.
//

import Foundation
import SwiftUI

/// A popup that displays at the bottom of the parent view and displays text.
///
/// ``` @StateObject private var popupStateManager = PopupStateManager()
///     // ...
///     VStack {
///         Button("Show message!") {
///             self.popupStateManager.activatePopup()
///         }
///         // ...
///     }
///     .withFeedbackPopup(text: "Hello World", popupStateManager: self.popupStateManager)
/// ```
struct YonderFeedbackPopup: ViewModifier {
    
    let text: String
    let color: Color
    let padding: CGFloat
    @ObservedObject var popupStateManager: PopupStateManager
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            feedbackPopupView
        }
    }
    
    private var feedbackPopupView: some View {
        VStack {
            Spacer()
            
            if self.popupStateManager.isShowing {
                Group {
                    YonderText(text: self.text, size: .buttonBody, color: self.color)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(YonderColors.backgroundMaxDepth)
                .border(YonderColors.border, width: YonderCoreGraphics.borderWidth)
                .padding(self.padding)
                .transition(.opacity)
                .onTapGesture {
                    self.popupStateManager.deactivatePopup()
                }
            }
        }
        .animation(.linear(duration: self.popupStateManager.transitionDuration), value: self.popupStateManager.isShowing)
    }
    
}
extension View {
    func withFeedbackPopup(text: String, color: Color = YonderColors.highlight, padding: CGFloat = YonderCoreGraphics.padding, popupStateManager: PopupStateManager) -> some View {
        modifier(YonderFeedbackPopup(text: text, color: color, padding: padding, popupStateManager: popupStateManager))
    }
}
