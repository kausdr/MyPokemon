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
    
    @StateObject private var viewModel = PokemonViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            // A lista agora contém NavigationLinks
            List(favoritePokemons) { pokemon in // O id é pego automaticamente do Identifiable
                // Criamos o NavigationLink que leva para a PokemonDetailView
                NavigationLink(destination: PokemonDetailView(
                    // Criamos um PokemonInfo a partir do nosso Pokemon favoritado
                    pokemonInfo: PokemonInfo(id: pokemon.id, name: pokemon.name),
                    viewModel: viewModel
                )) {
                    // O que aparece na lista
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Favoritos")
        }
        .onAppear {
            // Precisamos configurar o viewModel aqui também para a DetailView funcionar
            viewModel.setup(modelContext: modelContext)
        }
    }
}
