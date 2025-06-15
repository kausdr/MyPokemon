//
//  PokemonDetailView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//
import SwiftUI

struct PokemonDetailView: View {
    // A View recebe a informação inicial da lista
    let pokemonInfo: PokemonInfo
    @ObservedObject var viewModel: PokemonViewModel
    
    // E tem um estado para guardar os detalhes completos quando chegarem da API
    @State private var detailedPokemon: Pokemon?
    
    private var isFavorite: Bool {
        viewModel.favorites.contains { $0.name == pokemonInfo.name }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Mostra um indicador de progresso enquanto os detalhes carregam
            if let pokemon = detailedPokemon {
                if let urlString = pokemon.spriteURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 150)
                    }
                    .frame(maxWidth: .infinity) // Centraliza a imagem
                }
                Text("Tipos:")
                    .font(.title2)
                ForEach(pokemon.types, id: \.id) { type in
                    Text(type.name.capitalized)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                Spacer()
            } else {
                ProgressView("Carregando detalhes...")
            }
        }
        .padding()
        .navigationTitle(pokemonInfo.name.capitalized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        viewModel.toggleFavorite(pokemonInfo: pokemonInfo)
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            // Quando a View aparece, chama a função para buscar os detalhes
            viewModel.fetchDetails(for: pokemonInfo.name) { pokemonComDetalhes in
                self.detailedPokemon = pokemonComDetalhes
            }
        }
    }
}
