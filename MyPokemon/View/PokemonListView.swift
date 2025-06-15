//
//  PokemonListView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            NavigationStack { // É bom ter um NavigationStack aqui
                List {
                    // O 'ForEach' agora itera sobre a lista de 'PokemonInfo'
                    ForEach(viewModel.pokemons) { pokemon in // 'pokemon' aqui é um PokemonInfo
                        NavigationLink(destination: PokemonDetailView(pokemonInfo: pokemon, viewModel: viewModel)) {
                            Text(pokemon.name.capitalized)
                        }
                    }
                }
                .navigationTitle("Pokémon")
                .overlay {
                    if viewModel.pokemons.isEmpty {
                        ProgressView("Carregando Pokémon...")
                    }
                }
            }
            .tabItem {
                Label("Pokémon", systemImage: "house")
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
                
                if viewModel.pokemons.isEmpty {
                    viewModel.loadPokemons()
                }
            }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
        }
    }
}
