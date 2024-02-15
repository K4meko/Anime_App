
import SwiftUI

struct ResultView: View {
@EnvironmentObject var animeInfo: AnimeInfo
    


    var body: some View {
        Text("\(animeInfo.test)")
    }
}

#Preview {
    ResultView()
}
