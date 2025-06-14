//
//  FavoritesView.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//
import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PokemonViewModel
    
    var body: some View {
        VStack {
            Text("Favoritos")
                .font(.largeTitle).bold()
            List(viewModel.favorites, id: \.name) { pokemon in
                Text(pokemon.name.capitalized)
            }
        }
    }
}
