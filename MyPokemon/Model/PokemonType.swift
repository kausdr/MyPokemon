//
//  PokemonType.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import SwiftData


@Model
class PokemonType {
    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
