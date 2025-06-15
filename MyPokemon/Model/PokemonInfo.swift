//
//  PokemonInfo.swift
//  MyPokemon
//
//  Created by user276495 on 14/06/25.
//

import Foundation

// Um struct simples para representar os dados da API
struct PokemonInfo: Identifiable {
    // Usamos o nome como ID, já que é único na API
    var id: String { name }
    let name: String
    // Adicionaremos mais detalhes aqui depois, se necessário
}
