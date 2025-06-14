//
//  PokemonDetailView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .bold()
            
            Text("Tipos:")
                .font(.title2)
            
            ForEach(pokemon.types, id: \.id) { type in
                Text(type.name.capitalized)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(pokemon.name.capitalized)
    }
}
