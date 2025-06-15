//
//  Pokemon.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import SwiftData

@Model
class Pokemon {
    var name: String
    var types: [PokemonType]
    var spriteURL: String?

    init(name: String, types: [PokemonType], spriteURL: String? = nil) {
        self.name = name
        self.types = types
        self.spriteURL = spriteURL
    }
}
