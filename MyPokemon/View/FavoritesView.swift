//
//  FavoritesView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @ObservedObject var viewModel: PokemonViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.favorites) { pokemon in
                NavigationLink(destination: PokemonDetailView(
                    pokemonInfo: PokemonInfo(id: pokemon.id, name: pokemon.name),
                    viewModel: viewModel
                )) {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Favoritos")
        }
    }
}
