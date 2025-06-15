//
//  FavoritesView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//
import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \Pokemon.name) private var favoritePokemons: [Pokemon]
    
    var body: some View {
        NavigationStack {
            VStack {
                List(favoritePokemons, id: \.name) { pokemon in
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Favoritos")
        }
    }
}
