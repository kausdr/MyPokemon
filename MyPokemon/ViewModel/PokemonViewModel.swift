//
//  PokemonViewModel.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var favorites: [Pokemon] = []
    
    private let service = PokemonAPIService()
    
    func loadPokemons() {
        service.fetchAllPokemons { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonBasics):
                    self.pokemons = pokemonBasics.map {
                        Pokemon(name: $0.name, types: []) // carregar tipos depois
                    }
                case .failure(let error):
                    print("Erro: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleFavorite(pokemon: Pokemon) {
        if favorites.contains(where: { $0.name == pokemon.name }) {
            favorites.removeAll { $0.name == pokemon.name }
        } else {
            favorites.append(pokemon)
        }
    }
}
