//
//  SortOptions.swift
//  MyPokemon
//
//  Created by user276495 on 15/06/25.
//

import Foundation

// Opções de por qual campo ordenar
enum SortOption: String, CaseIterable, Identifiable {
    case pokedexNumber = "Pokédex Number"
    case alphabetical = "Alphabetical"
    
    var id: Self { self }
}

// Opções de ordem crescente ou decrescente
enum SortOrder: String, CaseIterable, Identifiable {
    case ascending = "Ascending"
    case descending = "Descending"
    
    var id: Self { self }
}
