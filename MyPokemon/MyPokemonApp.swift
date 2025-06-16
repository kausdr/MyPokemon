//
//  MyPokemonApp.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import SwiftUI
import SwiftData

@main
struct MyPokemonApp: App {
    @StateObject var authViewModel = UserAuthViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pokemon.self,
            PokemonType.self,
            User.self,
            Stat.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
