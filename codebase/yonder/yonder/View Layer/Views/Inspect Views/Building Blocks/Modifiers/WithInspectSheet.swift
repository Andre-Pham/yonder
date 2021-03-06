//
//  WithInspectSheet.swift
//  yonder
//
//  Created by Andre Pham on 13/2/2022.
//

import Foundation
import SwiftUI

struct WithInspectSheet: ViewModifier {
    @Binding var isPresented: Bool
    let pageGeometry: GeometryProxy
    var viewContent: AnyView
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: self.$isPresented) {
                InspectSheet(pageGeometry: self.pageGeometry) {
                    self.viewContent
                }
            }
    }
}
extension View {
    func withInspectSheet(isPresented: Binding<Bool>, pageGeometry: GeometryProxy, content: AnyView) -> some View {
        modifier(WithInspectSheet(isPresented: isPresented, pageGeometry: pageGeometry, viewContent: content))
    }
}

struct InspectSheet<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    private let content: () -> Content
    
    let pageGeometry: GeometryProxy
    
    init(pageGeometry: GeometryProxy, @ViewBuilder builder: @escaping () -> Content) {
        self.pageGeometry = pageGeometry
        self.content = builder
    }
    
    var body: some View {
        ZStack {
            YonderColors.backgroundMaxDepth
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                content()
                    .padding(.top)
                    .padding(.horizontal)
            }
            .frame(
                width: self.pageGeometry.size.width-YonderCoreGraphics.padding*4,
                height: self.pageGeometry.size.height)
            
            Rectangle()
                .stroke(YonderColors.border, lineWidth: YonderCoreGraphics.borderWidth)
                .frame(
                    width: self.pageGeometry.size.width-YonderCoreGraphics.padding*4,
                    height: self.pageGeometry.size.height)
        }
        .onTapGesture {
            dismiss()
        }
    }
}
