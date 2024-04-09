import SwiftUI

@MainActor
class ResultItemViewModel: ObservableObject {

    @Published var animeInfo: Media?

    func fetchAnimeInfo(animeId: Int) async {
        let query = """
            query ($id: Int) {
                Media (id: $id, type: ANIME) {
                    id
                    title {
                        romaji
                        english
                        native
                    }
                    startDate {
                        year
                        month
                        day
                    }
                    endDate {
                        year
                        month
                        day
                    }
                    episodes
                    coverImage {
                        extraLarge
                        large
                        medium
                        color
                    }
                    averageScore
                    popularity
                    meanScore
                    characters {
                        edges {
                            id
                        }
                    }
                }
            }
        """
        
        let variables = ["id": animeId]
        let url = URL(string: "https://graphql.anilist.co")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ["query": query, "variables": ["id": animeId]])
            urlRequest.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Something went wrong")
                return
            }

            let jsonString = String(data: data, encoding: .utf8)
            //print("JSON Response: \(jsonString ?? "Empty")")

            let jsondata = jsonString!.data(using: .utf8)!
            do {
                let animeResponse = try JSONDecoder().decode(AnimeResponse.self, from: jsondata)
                self.animeInfo = animeResponse.data.Media
                print(animeInfo?.title.romaji as Any)
                
            } catch {
                print("Error decoding JSON: \(error)")
            }

        } catch {
            print("Error: \(error)")
        }

    }
    
    func initialize(animeId: Int) async {
        await fetchAnimeInfo(animeId: animeId)
    }
    func checkIfSame(eng: String, romaji: String) -> Bool {
        if eng.lowercased() == romaji.lowercased()
        { return true }
       
        return false
    }
    func convertToMinutesAndSeconds(decimal: Double) -> String {
      let timeInterval = TimeInterval(decimal)
      let minutes = Int(timeInterval / 60)
      let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
      var strSeconds = false;
        for i in 1 ... 10
        {
            if seconds.isMultiple(of: i){
                strSeconds = true
            }
        }
        if strSeconds{
            return String("\(minutes):0\(seconds)")
        }
        
      return String("\(minutes):\(seconds)")
    }
}
