//
//  Pokemon.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import SwiftData

@Model
class Pokemon {
    @Attribute(.unique) var name: String
    var id: Int
    var types: [PokemonType]
    var spriteURL: String?
    var height: Int // em decímetros
    var weight: Int // em hectogramas
    var abilities: [String]
    
    @Relationship(deleteRule: .cascade) var stats: [Stat]

    init(id: Int = 0, name: String, types: [PokemonType] = [], spriteURL: String? = nil, height: Int = 0, weight: Int = 0, abilities: [String] = [], stats: [Stat] = []) {
        self.id = id
        self.name = name
        self.types = types
        self.spriteURL = spriteURL
        self.height = height
        self.weight = weight
        self.abilities = abilities
        self.stats = stats
    }
    
    var heightInMeters: String {
        return String(format: "%.1f m", Double(height) / 10.0)
    }
    
    var weightInKilograms: String {
        return String(format: "%.1f kg", Double(weight) / 10.0)
    }
}
