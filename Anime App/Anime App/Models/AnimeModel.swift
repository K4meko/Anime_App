import Foundation

struct AnimeResponse: Codable {
    let data: AnimeData
}

struct AnimeData: Codable {
    let Media: Media
}

struct Media: Codable {
    let id: Int
    let title: Title
    let startDate: DateInfo
    let endDate: DateInfo
    let episodes: Int
    let coverImage: CoverImage?
    let averageScore: Int
    let popularity: Int
    let meanScore: Int
    let characters: Characters
}

struct Title: Codable {
    let romaji: String
    let english: String?
    let native: String
}

struct DateInfo: Codable {
    let year: Int
    let month: Int
    let day: Int
}

struct CoverImage: Codable {
    let extraLarge: String
    let large: String
    let medium: String
    let color: String?
}

struct Characters: Codable {
    let edges: [CharacterEdge]
}

struct CharacterEdge: Codable {
    let id: Int
    // Add other properties if needed
}

