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
                    self.pokemons = pokemonBasics.map { PokemonInfo(name: $0.name) }
                    print("Lista de Pokémon carregada com \(self.pokemons.count) nomes.")
                case .failure(let error):
                    print("Erro ao carregar Pokémons: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 3. 'toggleFavorite' agora recebe um 'PokemonInfo'
    func toggleFavorite(pokemonInfo: PokemonInfo) {
        guard let modelContext = modelContext else { return }

        let pokemonName = pokemonInfo.name
        let fetchDescriptor = FetchDescriptor<Pokemon>(
            predicate: #Predicate { $0.name == pokemonName }
        )

        do {
            if let existingFavorite = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(existingFavorite)
                print("\(pokemonInfo.name.capitalized) removido dos favoritos.")
            } else {
                // Cria o @Model 'Pokemon' a partir do 'PokemonInfo' para salvar
                let newFavorite = Pokemon(name: pokemonInfo.name, types: [])
                modelContext.insert(newFavorite)
                print("\(pokemonInfo.name.capitalized) adicionado aos favoritos.")
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
