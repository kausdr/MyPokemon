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
    @EnvironmentObject var authViewModel: UserAuthViewModel
    
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredPokemons) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemonInfo: pokemon, viewModel: viewModel)) {
                                VStack {
                                    Text(String(format: "#%03d", pokemon.id))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(pokemon.name.capitalized)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
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
                            Menu("Generation") {
                                ForEach(viewModel.allGenerations) { generation in
                                    Button(generation.name.capitalized) {
                                        viewModel.switchFilter(to: generation.name)
                                    }
                                }
                            }
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
                            Picker("Sort by", selection: $viewModel.sortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
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
                viewModel.setup(modelContext: modelContext, currentUser: authViewModel.currentUser)
                if viewModel.pokemons.isEmpty {
                    viewModel.loadPokemons()
                }
            }
            .tabItem {
                Label("Pokémon", systemImage: "list.bullet")
            }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
    }
}
