//
//  PlayerView.swift
//  yonder
//
//  Created by Andre Pham on 10/12/21.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var player: PlayerUI
    @State private var showingPlayerSheet = false
    
    var body: some View {
        Button {
            showingPlayerSheet.toggle()
        } label: {
            VStack(alignment: .leading, spacing: 3) {
                Text("You")
                    .font(YonderFonts.main())
                    .padding(.top)
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    Text("\(player.armorPoints)")
                        .font(YonderFonts.main(size: 26))
                    
                    Spacer()
                    
                    Text("/\(player.maxArmorPoints)")
                        .font(YonderFonts.main(size: 18))
                }
                .padding(.leading)
                .padding(.trailing)
                
                HStack {
                    Text("\(player.health)")
                        .font(YonderFonts.main(size: 26))
                    
                    Spacer()
                    
                    Text("/\(player.maxHealth)")
                        .font(YonderFonts.main(size: 18))
                }
                .padding(.leading)
                .padding(.trailing)
                
                Text("$\(player.gold)")
                    .font(YonderFonts.main(size: 26))
                    .padding(.leading)
                
                Spacer()
            }
            .foregroundColor(.Yonder.textMaxContrast)
            .background(Color.Yonder.backgroundMinDepth)
        }
        .sheet(isPresented: $showingPlayerSheet) {
            Text("Wow!")
        }
    }
}

struct PlayerComponent_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: PlayerUI(Player(maxHealth: 200, location: NoLocation())))
    }
}
