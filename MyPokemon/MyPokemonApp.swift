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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pokemon.self,
            PokemonType.self,
            User.self,
            Stat.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PokemonListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
