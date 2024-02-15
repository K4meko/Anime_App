import SwiftUI

struct ErrorView: View {
    var body: some View {
        ZStack{
            VStack{
                Image(systemName: "water.waves").resizable().aspectRatio(contentMode: .fit).frame(width: 500).foregroundStyle(.purple)
                Spacer().frame(height: 60)
                Image(systemName: "water.waves").resizable().aspectRatio(contentMode: .fit).frame(width: 500).foregroundStyle(.purple)
            }
            ZStack{
                RoundedRectangle(cornerRadius: 20).frame(width: 350, height: 180).foregroundStyle(.white).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 2)).frame(width: 350, height: 180)
                    )
                VStack{
                    Spacer()
                    Text("Something went wrong!").font(.title).bold()
                    Text("Try again ").font(.title2)
                    Spacer()
                    
                }
            }
        }
    }
}

#Preview {
    ErrorView()
}
