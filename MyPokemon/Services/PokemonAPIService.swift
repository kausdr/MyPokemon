//
//  PokemonAPIService.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import Foundation

struct PokemonAPIService {
    
    struct PokemonBasic: Codable {
        let name: String
        let url: String
    }
    
    private struct PokemonListResponse: Codable {
        let results: [PokemonBasic]
    }
    
    private struct Sprites: Codable {
        let front_default: String?
    }
    
    private struct PokemonResponse: Codable {
        let id: Int
        let name: String
        let types: [TypeEntry]
        let sprites: Sprites
        let height: Int
        let weight: Int
        let abilities: [AbilityInfo]
        let stats: [StatInfo]
    }

    private struct TypeEntry: Codable {
        let slot: Int
        let type: TypeDetail
    }

    private struct TypeDetail: Codable {
        let name: String
        let url: String
    }
    
    private struct AbilityInfo: Codable {
        let ability: AbilityName
    }
    
    private struct AbilityName: Codable {
        let name: String
    }
    
    private struct StatInfo: Codable {
        let base_stat: Int
        let stat: StatName
    }
    
    private struct StatName: Codable {
        let name: String
    }
    
    private func extractTypeId(from url: String) -> Int? {
        guard let lastComponent = url.split(separator: "/").filter({ !$0.isEmpty }).last,
              let id = Int(lastComponent) else {
            return nil
        }
        return id
    }
    
    func fetchAllPokemons(completion: @escaping (Result<[PokemonBasic], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL Inválida", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Dados não recebidos", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(PokemonListResponse.self, from: data)
                completion(.success(apiResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemon(named name: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL Inválida", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Dados não recebidos", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(PokemonResponse.self, from: data)
                
                let pokemonTypes: [PokemonType] = apiResponse.types.compactMap { typeEntry in
                    guard let id = extractTypeId(from: typeEntry.type.url) else { return nil }
                    return PokemonType(id: id, name: typeEntry.type.name)
                }
                let abilities = apiResponse.abilities.map { $0.ability.name.capitalized }
                let stats = apiResponse.stats.map { Stat(name: $0.stat.name, value: $0.base_stat) }
                
                // Crie o objeto Pokemon, agora incluindo a URL do sprite
                let pokemon = Pokemon(
                    id: apiResponse.id,
                    name: apiResponse.name,
                    types: pokemonTypes,
                    spriteURL: apiResponse.sprites.front_default, // Salva a URL
                    height: apiResponse.height, // Salva a Altura
                    weight: apiResponse.weight, // Salva o Peso
                    abilities: abilities, // Salva as Habilidades
                    stats: stats // Salva os Status
                )
                completion(.success(pokemon))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func decodePokemon(from data: Data) throws -> Pokemon {
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(PokemonResponse.self, from: data)
        let pokemonTypes: [PokemonType] = apiResponse.types.compactMap { typeEntry in
            guard let id = extractTypeId(from: typeEntry.type.url) else { return nil }
            return PokemonType(id: id, name: typeEntry.type.name)
        }
        return Pokemon(name: apiResponse.name, types: pokemonTypes)
    }
}
