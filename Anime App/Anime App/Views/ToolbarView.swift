//
//  Toolbar.swift
//  Anime App
//
//  Created by Eliška Pavlů on 26.01.2024.
//

import SwiftUI

enum Icon{
    case home;
    case history
}

struct Toolbar: View {
    @State var selected: Icon = .home
    var body: some View {
        VStack(){
            HStack{
                Spacer()
                Image(systemName: "house.fill").resizable().aspectRatio(contentMode: .fit).frame(width:30).foregroundStyle(selected == .home ? .purple : .gray).onTapGesture {
                    selected = .home
                }
                Spacer()
                Image(systemName: "books.vertical.fill").resizable().aspectRatio(contentMode: .fit).frame(width:30).foregroundStyle(selected == .history ? .purple : .gray).onTapGesture {
                    selected = .history
                }
                Spacer()
            }
            .padding(.top, 27)
        }.border(width: CGFloat(2), edges: [.top], color: Color(hex: "#e6e6e6"))
        
    }
}

#Preview {
    Toolbar()
}
