import SwiftUI

struct EpisodeView: View {
    @EnvironmentObject var animeInfo: AnimeInfo

    var body: some View {
        if animeInfo.errorProp != nil{
            ErrorView()
        }
        else{
            if let animeResult = animeInfo.AnimeStruct?.result{
                
                ScrollView {
                    ForEach(animeResult, id: \.self){ r in
                        ResultItemView(test: r).frame(width: 350).padding(.horizontal, 20)
                    }
                    Spacer().frame(height: 20)
                }.frame(width: 600)
                
            } else {
                LoadingView()
            }
        }
   }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(2) // Adjust the size of the loading indicator
        }
        .padding()
        .background(Color.white.opacity(0.8)) // Add a semi-transparent background
        .cornerRadius(10)
    }
}

#Preview {
    EpisodeView().environmentObject(AnimeInfo())
}
