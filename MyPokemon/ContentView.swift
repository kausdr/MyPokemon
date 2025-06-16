//
//  ContentView.swift
//  MyPokemon
//
//  Created by user276516 on 6/15/25.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: UserAuthViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if authViewModel.currentUser != nil {
                VStack {
                    HStack {
                        Spacer()
                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }

                    PokemonListView()
                        .environmentObject(authViewModel)
                }
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.setup(modelContext: modelContext)
        }
    }
}

