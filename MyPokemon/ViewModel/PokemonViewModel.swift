//
//  PokemonViewModel.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import Foundation
import SwiftData

@MainActor
class PokemonViewModel: ObservableObject {
    // 1. A lista principal agora usa o struct 'PokemonInfo'
    @Published var pokemons: [PokemonInfo] = []
    
    // A lista de favoritos continua usando o @Model 'Pokemon'
    @Published var favorites: [Pokemon] = []
    
    private let service = PokemonAPIService()
    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchFavorites()
    }
    
    // 2. 'loadPokemons' agora cria objetos 'PokemonInfo'
    func loadPokemons() {
        service.fetchAllPokemons { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonBasics):
                    // Mapeia o resultado da API para o nosso novo struct
                    self.pokemons = pokemonBasics.compactMap { basicInfo in
                        // Garante que o ID foi extraído com sucesso
                        guard let id = basicInfo.id else { return nil }
                        return PokemonInfo(id: id, name: basicInfo.name)
                    }
                    print("Lista de Pokémon carregada com \(self.pokemons.count) nomes.")
                case .failure(let error):
                    print("Erro ao carregar Pokémons: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 3. 'toggleFavorite' agora recebe um 'PokemonInfo'
    func toggleFavorite(pokemon: Pokemon) {
        guard let modelContext = modelContext else { return }

        let pokemonName = pokemon.name
        let fetchDescriptor = FetchDescriptor<Pokemon>(
            predicate: #Predicate { $0.name == pokemonName }
        )

        do {
            if let existingFavorite = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(existingFavorite)
                print("\(pokemon.name.capitalized) removido dos favoritos.")
            } else {
                let favoriteToInsert = Pokemon(
                   id: pokemon.id,
                   name: pokemon.name,
                   types: pokemon.types,
                   spriteURL: pokemon.spriteURL,
                   height: pokemon.height,
                   weight: pokemon.weight,
                   abilities: pokemon.abilities,
                   stats: pokemon.stats
               )
               modelContext.insert(favoriteToInsert)
               print("\(pokemon.name.capitalized) adicionado aos favoritos com ID: \(pokemon.id).")
            }
            fetchFavorites() // Atualiza a lista de favoritos
        } catch {
            print("Falha ao favoritar: \(error)")
        }
    }
    
    // 'fetchFavorites' continua igual, buscando o @Model 'Pokemon'
    private func fetchFavorites() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Pokemon>(sortBy: [SortDescriptor(\.name)])
            self.favorites = try modelContext.fetch(descriptor)
            print("Favoritos do banco carregados: \(self.favorites.count) pokémons.")
        } catch {
            print("Falha ao carregar os favoritos do banco: \(error)")
        }
    }
    
    func fetchDetails(for pokemonName: String, completion: @escaping (Pokemon) -> Void) {
        service.fetchPokemon(named: pokemonName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailedPokemon):
                    // Quando a busca tem sucesso, retorna o Pokémon com os detalhes
                    completion(detailedPokemon)
                case .failure(let error):
                    print("Erro ao buscar detalhes para \(pokemonName): \(error.localizedDescription)")
                }
            }
        }
    }
}
