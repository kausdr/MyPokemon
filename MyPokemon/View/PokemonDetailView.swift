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
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    if let pokemon = detailedPokemon {
                        VStack(spacing: 16) {
                            // Imagem
                            if let urlString = pokemon.spriteURL, let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 220)
                            }
                            
                            // Nome do Pokémon
                            Text(pokemon.name.capitalized)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white) // Cor branca para contrastar com o fundo
                                .shadow(radius: 3) // Sombra para legibilidade
                            
                            // Tipos
                            HStack(spacing: 10) {
                                ForEach(pokemon.types, id: \.id) { type in
                                    Text(type.name.capitalized)
                                        .padding(.horizontal, 16).padding(.vertical, 8)
                                        .background(colorFor(typeName: type.name))
                                        .foregroundColor(.white).font(.headline).cornerRadius(20)
                                        .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(
                            Group {
                                if let primaryType = pokemon.types.first?.name {
                                    Image(backgroundImageFor(typeName: primaryType))
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.9)
                                }
                            }
                        )
                        .cornerRadius(25)
                        .padding(.horizontal)
                        
                        // Dados da Pokédex
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Pokédex Data").font(.title2).bold()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Height").font(.headline)
                                    Text(pokemon.heightInMeters).font(.body)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Weight").font(.headline)
                                    Text(pokemon.weightInKilograms).font(.body)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Pokédex Nº").font(.headline)
                                    Text("#\(pokemon.id)").font(.body)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Habilidades
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Abilities").font(.title2).bold()
                            Text(pokemon.abilities.joined(separator: ", "))
                        }
                        .padding(.horizontal)
                        
                        // Status Base
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Base Stats").font(.title2).bold()
                            ForEach(pokemon.stats, id: \.name) { stat in
                                HStack {
                                    Text(stat.name.capitalized).frame(width: 80, alignment: .leading)
                                    // Barra de progresso para visualização
                                    ProgressView(value: Double(stat.value), total: 255)
                                        .tint(stat.value > 75 ? .green : .orange)
                                    Text("\(stat.value)").frame(width: 40)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    } else {
                        ProgressView("Carregando detalhes...")
                            .frame(maxWidth: .infinity, minHeight: 500)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(pokemonInfo.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    guard let pokemonToFavorite = detailedPokemon else { return }
                    withAnimation {
                        viewModel.toggleFavorite(pokemon: pokemonToFavorite)
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            if detailedPokemon == nil {
                viewModel.fetchDetails(for: pokemonInfo.name) { pokemonComDetalhes in
                    self.detailedPokemon = pokemonComDetalhes
                }
            }
        }
    }
}
