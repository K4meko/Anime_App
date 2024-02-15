import Foundation

struct AnimeSearchResult: Decodable {
    let frameCount: Int
    let error: String
    var result: [AnimeResult]
}
struct AnimeResult: Decodable {
    let anilist: Int
    let filename: String
    let episode: Episode?
    let from: Double
    let to: Double
    let similarity: Double
    let video: URL
    let image: URL

    enum Episode: Decodable, Hashable {
        case int(Int)
        case string(String)
        
        init(from decoder: Decoder) throws {
            if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
                self = .int(intValue)
            } else if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(stringValue)
            } else {
                throw DecodingError.typeMismatch(Episode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Episode cannot be decoded"))
            }
        }
    }
}

extension AnimeResult: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(anilist)
        hasher.combine(filename)
        hasher.combine(episode)
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(similarity)
        hasher.combine(video)
        hasher.combine(image)
    }
}

