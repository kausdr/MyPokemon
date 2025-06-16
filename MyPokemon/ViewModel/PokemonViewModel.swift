//
//  PokemonViewModel.swift
//  MyPokemon
//
//  Created by user276516 on 6/11/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonInfo] = []
    @Published var filteredPokemons: [PokemonInfo] = []
    @Published var favorites: [Pokemon] = []
    
    @Published var searchText = ""
    @Published var sortOption: SortOption = .pokedexNumber
    @Published var sortOrder: SortOrder = .ascending
    
    @Published var allTypes: [NamedAPIResource] = []
    @Published var allGenerations: [NamedAPIResource] = []
    
    private let service = PokemonAPIService()
    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFilteringAndSorting()
    }

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchFavorites()
        fetchAllFilterOptions()
    }
    
    private func setupFilteringAndSorting() {
        // Publicador que reage a mudanças na lista principal, texto de busca ou ordenação
        $pokemons
            .combineLatest($searchText, $sortOption, $sortOrder)
            // .debounce adiciona um pequeno atraso para não pesquisar a cada letra digitada
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { (pokemons, searchText, sortOption, sortOrder) in
                
                // --- 1. LÓGICA DE FILTRAGEM (PESQUISA) ---
                let filtered: [PokemonInfo]
                if searchText.isEmpty {
                    filtered = pokemons
                } else {
                    let lowercasedText = searchText.lowercased()
                    filtered = pokemons.filter { pokemon in
                        // Pesquisa por nome
                        let nameMatch = pokemon.name.lowercased().contains(lowercasedText)
                        // Pesquisa por número
                        let numberMatch = String(pokemon.id).contains(lowercasedText)
                        return nameMatch || numberMatch
                    }
                }
                
                // --- 2. LÓGICA DE ORDENAÇÃO ---
                switch sortOption {
                case .pokedexNumber:
                    return filtered.sorted {
                        sortOrder == .ascending ? $0.id < $1.id : $0.id > $1.id
                    }
                case .alphabetical:
                    return filtered.sorted {
                        sortOrder == .ascending ? $0.name < $1.name : $0.name > $1.name
                    }
                }
            }
            // O resultado final é atribuído à lista que a View observa
            .assign(to: \.filteredPokemons, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchAllFilterOptions() {
       service.fetchAllTypes { result in
           DispatchQueue.main.async {
               if case .success(let types) = result { self.allTypes = types }
           }
       }
       service.fetchAllGenerations { result in
           DispatchQueue.main.async {
               if case .success(let generations) = result { self.allGenerations = generations }
           }
       }
    }
    
    func switchFilter(to newFilter: String) {
        self.pokemons = []
        
        let handleResult: (Result<[PokemonAPIService.PokemonBasic], Error>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonBasics):
                    // A lógica para converter [PokemonBasic] para [PokemonInfo]
                    self.pokemons = pokemonBasics.compactMap { basicInfo in
                        guard let id = self.service.extractTypeId(from: basicInfo.url) ?? basicInfo.id else { return nil }
                        return PokemonInfo(id: id, name: basicInfo.name)
                    }
                case .failure(let error):
                    print("Erro ao aplicar filtro: \(error)")
                }
            }
        }
        
        // Verifica se é um filtro de tipo
        if let type = allTypes.first(where: { $0.name == newFilter }) {
            service.fetchPokemonsByType(typeName: type.name, completion: handleResult)
        // Verifica se é um filtro de geração
        } else if let generation = allGenerations.first(where: { $0.name == newFilter }) {
            if let genId = service.extractTypeId(from: generation.url) {
                service.fetchPokemonsByGeneration(generationId: genId, completion: handleResult)
            }
        // Caso "All", volta a carregar todos
        } else {
            loadPokemons() // Sua função original que carrega todos
        }
    }
    
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
