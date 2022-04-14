//
//  YonderText.swift
//  yonder
//
//  Created by Andre Pham on 29/12/21.
//

import Foundation
import SwiftUI
import MovingNumbersView // https://github.com/aunnnn/MovingNumbersView.git

enum YonderTextSize {
    
    case title1
    case title2
    case title3
    case title4
    
    case buttonBody
    case buttonBodySubscript
    case tabBar
    case tabBarIconCapsule
    
    case cardTitle
    case cardBody
    case cardSubscript
    
    case inspectSheetTitle
    case inspectSheetBody
    
    case optionBody
    
    var value: CGFloat {
        switch self {
        case .title1: return 70
        case .title2: return 35
        case .title3: return 25 // TEMP choice
        case .title4: return 20
            
        case .buttonBody: return 24
        case .buttonBodySubscript: return 18
        case .tabBar: return 14
        case .tabBarIconCapsule: return 28
            
        case .cardTitle: return 18
        case .cardBody: return 26
        case .cardSubscript: return 18
        
        case .inspectSheetTitle: return 28
        case .inspectSheetBody: return 20
            
        case .optionBody: return 16
        }
    }
    
    // Only confirmed to work with main font Mx437_DOS-V_TWN16 (AKA DOS/V TWN16)
    var height: CGFloat {
        return self.value
    }
    var width: CGFloat {
        return self.value*8/16 // 8:16 ratio
    }
    
}

struct YonderText: View {
    let text: String
    let size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    var multilineTextAlignment: TextAlignment = .leading
    
    var body: some View {
        Text(self.text)
            .font(YonderFonts.main(size: self.size.value))
            .foregroundColor(self.color)
            .multilineTextAlignment(self.multilineTextAlignment)
            .fixedSize(horizontal: false, vertical: true) // Text wraps instead of being cut off
    }
}

struct YonderNumeral: View {
    let number: Int
    let size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    var animationIsActive: Bool = true
    
    var body: some View {
        MovingNumbersView(
            number: Double(self.number),
            numberOfDecimalPlaces: 0,
            // Work around for iOS15 bug that causes single-digit numbers with exact width to not appear
            // https://github.com/aunnnn/MovingNumbersView/issues/3
            // 15% extra padding isn't that noticeable and fixes the issue
            fixedWidth: (self.number < 10 && self.number > -10) ? self.size.width*(self.number < 0 ? 2 : 1)*1.15 : nil,
            animationDuration: self.animationIsActive ? 0.6 : 0.0) { str in
                // Builds each character
                YonderText(text: str, size: self.size, color: self.color)
        }
    }
}

/// Creates a combination of text and numerals with the ordering based on the formatting provided.
///
/// Example:
/// ``` format: [.text, .numeral, .text]
///     text: ["Health: ", "%"]
///     numbers: [500]
/// ```
/// Produces:
/// ``` Health: 500% ```
struct YonderTextAndNumeral: View {
    let format: [YonderTextType]
    let text: [String]
    let numbers: [Int]
    let size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    var animationIsActive: Bool = true
    
    var body: some View {
        var textReversed = Array(text.reversed())
        var numbersReversed = Array(numbers.reversed())
        HStack(spacing: 0) {
            ForEach(self.format, id: \.self) { textType in
                switch textType {
                case .text:
                    if let text = textReversed.popLast() {
                        YonderText(text: text, size: self.size, color: self.color)
                    }
                case .numeral:
                    if let num = numbersReversed.popLast() {
                        YonderNumeral(number: num, size: self.size, color: self.color, animationIsActive: self.animationIsActive)
                    }
                }
            }
        }
    }
}

enum YonderTextType {
    case text
    case numeral
}

struct YonderIconTextPair: View {
    let image: Image
    let text: String
    let size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    
    var body: some View {
        HStack {
            YonderIcon(image: self.image)
            
            YonderText(text: self.text, size: self.size, color: self.color)
        }
    }
}

struct YonderIconNumeralPair: View {
    var prefix: String = ""
    let image: Image
    let numeral: Int
    let size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    var animationIsActive: Bool = true
    
    var body: some View {
        HStack {
            YonderIcon(image: self.image)
            
            if prefix.count > 0 {
                YonderTextAndNumeral(format: [.text, .numeral], text: [self.prefix], numbers: [self.numeral], size: self.size, color: self.color, animationIsActive: self.animationIsActive)
            }
            else {
                YonderNumeral(number: self.numeral, size: self.size, color: self.color, animationIsActive: self.animationIsActive)
            }
        }
    }
}
