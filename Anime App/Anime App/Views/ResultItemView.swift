import AVKit
import URLImage
import SwiftUI


struct Test{
    let anilist =  3588
    let filename: String = "[EMD][Soul_Eater][BDRIP][04][X264_AAC][720P].mp4"
    let episode: Int = 17
    let from: Double = 134.67
    let to: Double = 134.75
    let similarity: Double = 0.7399136534702245
    let video: URL = URL(string: "https://media.trace.moe/video/3588/%5BEMD%5D%5BSoul_Eater%5D%5BBDRIP%5D%5B17%5D%5BX264_AAC%5D%5B720P%5D.mp4?t=134.70999999999998&now=1706814000&token=96dfmuPRcI2YqrGQFsQ22lMRwY")!
    let image: URL = URL(string: "https://media.trace.moe/image/98497/Tokubetsuban%20Free!%20Take%20Your%20Marks%20-%2001%20(BD%201280x720%20x264%20AACx3).mp4.jpg?t=321.78999999999996&now=1707148800&token=5nHEjrwLxzCyukpY5ZIMIg26fDE")!
}

struct ResultItemView: View {
    func multiplyBy100(_ num: Double) -> Double{
        return (num * 100)
    }
    private func loadImage() {
        URLSession.shared.dataTask(with: test.image) { data, response, error in
               DispatchQueue.main.async {
                   if let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let contentType = httpResponse.allHeaderFields["Content-Type"] as? String,
                      contentType.hasPrefix("image") {
                       // Image loaded successfully
                       isImageLoaded = true
                   } else {
                       // Image failed to load
                       isImageLoaded = false
                   }
               }
           }.resume()
       }
    var test: AnimeResult
    @State private var isImageLoaded = false
    @StateObject var viewModel: ResultItemViewModel = ResultItemViewModel()
    
    var body: some View {
   
            VStack(alignment: .leading){
                if let animetitle = viewModel.animeInfo?.title {
                    
                    if let animeTitleEng = animetitle.english
                    {
                        if !viewModel.checkIfSame(eng: animeTitleEng, romaji: animetitle.romaji) {
                            HStack{
                                Text("Anime: ").bold()
                                Text("\(animetitle.romaji) / \(animeTitleEng)")
                            }
                        }
                        else{
                            HStack{
                                Text("Anime: ").bold();
                                Text("\(animetitle.romaji)")
                            }
                        }
                    }
                    else{
                        HStack{
                            Text("Anime: ").bold();
                            Text("\(animetitle.romaji)")
                        }
                    }
                }
                else {
                    Text(viewModel.animeInfo?.title.romaji ?? "Could not get the anime title")
                }
                if let episode = test.episode{
                    HStack{
                        Text("Episode: ").bold()
                        switch episode {
                        case .int(let intValue):
                            Text("\(intValue)")
                        case .string(let stringValue):
                            Text("\(stringValue)")
                        }
                    }
                }
                else {HStack{
                    Text("Episode: ").bold()
                    Text("None")
                }
                }
                HStack{
                    Text("Episode time: ").bold()
                    Text("\(viewModel.convertToMinutesAndSeconds(decimal:test.from))")
                }
                HStack{
                    Text("Similiarity: ").bold()
                    Text("\(multiplyBy100(test.similarity).rounded().formatted())%")
                }
//                if isImageLoaded {
//                    URLImage(test.image) { image in
//                                   image
//                            .resizable()
//                                       .aspectRatio(contentMode: .fit)
//                                      // .frame(width: 200, height: 200)
//                                       .clipShape(RoundedRectangle(cornerRadius: 10))
//                               }
//                           } else {
//                               ZStack{
//                                   RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).frame(width: 270, height: 150)
//                                   Text("Image")
//                                       .foregroundColor(.black)
//                               }
//                           }
                       
                AsyncImage(url: test.image) { phase in
                    switch phase {
                    case .empty:
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).frame(width: 280, height: 150)
                            ProgressView().tint(.purple)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure(_):
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).frame(width: 280, height: 150)
                            Text("Failed to load Image") .foregroundColor(.black)
                        }
                    @unknown default:
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).frame(width: 280, height: 150)
                            Text("Placeholder") .foregroundColor(.black)
                        }
                    }
                }

            }.padding(10).background(.purple).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 10))
            
        .onAppear(perform: {
            Task{
                await viewModel.initialize(animeId: test.anilist)
                print(test.anilist)
            }
            loadImage()
        })
        
    }
    
}
