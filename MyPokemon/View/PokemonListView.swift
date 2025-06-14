//
//  PokemonListView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some View {
        TabView {
            List {
                ForEach(viewModel.pokemons, id: \.name) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
                        HStack {
                            Text(pokemon.name.capitalized)
                            Spacer()
                        }
                    }
                }
            }
            .tabItem {
                Label("Pokémon", systemImage: "house")
            }
            .onAppear {
                viewModel.loadPokemons()
            }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
        }
    }
}
