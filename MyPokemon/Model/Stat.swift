//
//  Stat.swift
//  MyPokemon
//
//  Created by user276495 on 15/06/25.
//

import SwiftData

@Model
class Stat {
    var name: String
    var value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}
