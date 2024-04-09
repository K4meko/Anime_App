//
//  Anime_AppApp.swift
//  Anime App
//
//  Created by Eliška Pavlů on 26.01.2024.
//

import SwiftUI

@main
struct Anime_AppApp: App {
    @StateObject var viewModel = ResultItemViewModel()
    @StateObject var animeInfo = AnimeInfo()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(animeInfo).preferredColorScheme(.light)
        }
    }
}
