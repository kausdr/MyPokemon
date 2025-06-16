//
//  User.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 04/06/25.
//

import SwiftData

@Model
class User {
    var userName: String
    var email: String
    var password: String
    @Relationship(deleteRule: .cascade) var favoritePokemons: [Pokemon]

    init(userName: String, email: String, password: String) {
        self.userName = userName
        self.email = email
        self.password = password
        self.favoritePokemons = []
    }
}
