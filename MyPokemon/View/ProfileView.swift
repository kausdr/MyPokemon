//
//  ProfileView.swift
//  MyPokemon
//
//  Created by Kauane S. R. on 16/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: UserAuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = authViewModel.currentUser {
                    Text("Olá, \(user.userName.capitalized)!")
                        .font(.title)
                        .padding()
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                    
                } else {
                    Text("Nenhum usuário logado.")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button("Sair da Conta") {
                    authViewModel.logout()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Spacer()
            }
            .navigationTitle("Meu Perfil")
        }
    }
}
