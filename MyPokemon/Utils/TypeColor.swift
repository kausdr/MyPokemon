//
//  TypeColor.swift
//  MyPokemon
//
//  Created by user276495 on 15/06/25.
//

import SwiftUI

// Esta função recebe o nome de um tipo e retorna uma cor correspondente
func colorFor(typeName: String) -> Color {
    switch typeName.lowercased() {
    case "grass":
        return Color(red: 0.48, green: 0.8, blue: 0.5)
    case "fire":
        return Color(red: 0.94, green: 0.5, blue: 0.31)
    case "water":
        return Color(red: 0.4, green: 0.58, blue: 0.95)
    case "electric":
        return Color(red: 0.98, green: 0.82, blue: 0.33)
    case "poison":
        return Color(red: 0.64, green: 0.43, blue: 0.64)
    case "flying":
        return Color(red: 0.67, green: 0.58, blue: 0.94)
    case "bug":
        return Color(red: 0.66, green: 0.72, blue: 0.3)
    case "normal":
        return Color(red: 0.67, green: 0.67, blue: 0.5)
    case "ground":
        return Color(red: 0.88, green: 0.75, blue: 0.42)
    case "fairy":
        return Color(red: 0.9, green: 0.6, blue: 0.69)
    case "fighting":
        return Color(red: 0.76, green: 0.25, blue: 0.21)
    case "psychic":
        return Color(red: 0.97, green: 0.44, blue: 0.53)
    case "rock":
        return Color(red: 0.72, green: 0.64, blue: 0.35)
    case "steel":
        return Color(red: 0.72, green: 0.72, blue: 0.81)
    case "ice":
        return Color(red: 0.6, green: 0.85, blue: 0.84)
    case "ghost":
        return Color(red: 0.45, green: 0.35, blue: 0.59)
    case "dragon":
        return Color(red: 0.44, green: 0.34, blue: 0.97)
    default:
        return Color.gray
    }
}
