import Foundation
import SwiftUI

class AnimeInfo: ObservableObject {
    
    @Published var AnimeStruct: AnimeSearchResult?
    @Published var animeInfo: Media?
    @Published var errorProp: String?

    func uploadImageToAPI(image: UIImage?) {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.9) else {
            print("Failed to convert image to data.")
            self.errorProp = "Failed to upload the image"

            return
        }

        let url = URL(string: "https://api.trace.moe/search")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error)")
            self.errorProp = String(error.localizedDescription)
            }
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let animeSearchResponse = try JSONDecoder().decode(AnimeSearchResult.self, from: data)
                        
                        self.AnimeStruct = animeSearchResponse
                        print("decoded: \(String(describing: self.AnimeStruct) )")
                        
                    } catch {
                        print("Error decoding JSON: \(error)")
                        //self.errorProp = error.localizedDescription
                    }
                }
            }
        }.resume()
    }
}

