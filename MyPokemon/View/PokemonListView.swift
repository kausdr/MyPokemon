//
//  PokemonListView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            NavigationStack { // É bom ter um NavigationStack aqui
                List(viewModel.filteredPokemons) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemonInfo: pokemon, viewModel: viewModel)) {
                        Text(String(format: "#%03d", pokemon.id)) // Formata para ter 3 dígitos, ex: #001
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(pokemon.name.capitalized)
                    }
                }
                .navigationTitle("Pokémon")
                .searchable(text: $viewModel.searchText, prompt: "Search by Name or Number")
                .overlay {
                    if viewModel.filteredPokemons.isEmpty && !viewModel.searchText.isEmpty {
                        ContentUnavailableView.search
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Button("All Pokémon") {
                                viewModel.switchFilter(to: "All")
                            }
                            
                            // Submenu para Gerações
                            Menu("Generation") {
                                ForEach(viewModel.allGenerations) { generation in
                                    Button(generation.name.capitalized) {
                                        viewModel.switchFilter(to: generation.name)
                                    }
                                }
                            }
                            
                            // Submenu para Tipos
                            Menu("Type") {
                                ForEach(viewModel.allTypes) { type in
                                    Button(type.name.capitalized) {
                                        viewModel.switchFilter(to: type.name)
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title3)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            // Picker para escolher o campo de ordenação
                            Picker("Sort by", selection: $viewModel.sortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            
                            // Picker para escolher a ordem
                            Picker("Order", selection: $viewModel.sortOrder) {
                                ForEach(SortOrder.allCases) { order in
                                    Text(order.rawValue).tag(order)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .font(.title3)
                        }
                    }
                }
                .overlay {
                    if viewModel.pokemons.isEmpty {
                        ProgressView("Carregando Pokémon...")
                    }
                }
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
                if viewModel.pokemons.isEmpty {
                    viewModel.loadPokemons()
                }
            }
            .tabItem {
                Label("Pokémon", systemImage: "list.bullet")
            }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
        }
    }
}
