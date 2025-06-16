//
//  LoginView.swift
//  MyPokemon
//
//  Created by user276516 on 6/15/25.
//
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: UserAuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login").font(.largeTitle.bold())
                TextField("Email", text: $email).textFieldStyle(.roundedBorder)
                SecureField("Senha", text: $password).textFieldStyle(.roundedBorder)

                Button("Entrar") {
                    viewModel.setup(modelContext: modelContext)
                    _ = viewModel.login(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)

                if let error = viewModel.loginError {
                    Text(error).foregroundColor(.red).font(.caption)
                }

                NavigationLink("Não tem conta? Cadastre-se", destination: CadastroView(viewModel: _viewModel))
                    .font(.caption)
            }
            .padding()
        }
    }
}

