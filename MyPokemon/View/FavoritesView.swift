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
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.favorites) { pokemon in
                        NavigationLink(destination: PokemonDetailView(
                            pokemonInfo: PokemonInfo(id: pokemon.id, name: pokemon.name),
                            viewModel: viewModel
                        )) {
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
            .navigationTitle("Favoritos")
        }
    }
}
