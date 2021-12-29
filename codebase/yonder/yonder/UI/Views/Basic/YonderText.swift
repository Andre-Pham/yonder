//
//  YonderText.swift
//  yonder
//
//  Created by Andre Pham on 29/12/21.
//

import Foundation
import SwiftUI

enum YonderTextSize {
    
    case title1
    case title2
    case title3
    case title4
    
    case buttonBody
    
    case cardTitle
    case cardBody
    case cardSubscript
    
    var value: CGFloat {
        switch self {
        case .title1: return 70
        case .title2: return 40 // TEMP choice
        case .title3: return 30 // TEMP choice
        case .title4: return 20
            
        case .buttonBody: return 24
            
        case .cardTitle: return 18
        case .cardBody: return 26
        case .cardSubscript: return 18
        }
    }
    
}

struct YonderText: View {
    var text: String
    var size: YonderTextSize
    var color: Color = Color.Yonder.textMaxContrast
    
    var body: some View {
        Text(text)
            .font(YonderFonts.main(size: size.value))
            .foregroundColor(color)
    }
}
