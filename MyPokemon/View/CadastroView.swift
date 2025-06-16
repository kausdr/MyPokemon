//
//  CadastroView.swift
//  MyPokemon
//
//  Created by user276516 on 6/15/25.
//
import SwiftUI

struct CadastroView: View {
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: UserAuthViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Cadastro").font(.largeTitle.bold())
            TextField("Nome de Usuário", text: $userName).textFieldStyle(.roundedBorder)
            TextField("Email", text: $email).textFieldStyle(.roundedBorder)
            SecureField("Senha", text: $password).textFieldStyle(.roundedBorder)

            Button("Cadastrar") {
                viewModel.setup(modelContext: modelContext)
                if viewModel.cadastrar(userName: userName, email: email, password: password) {
                    showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            if let error = viewModel.loginError {
                Text(error).foregroundColor(.red).font(.caption)
            }

            if showSuccess {
                Text("Cadastro realizado com sucesso!")
                    .foregroundColor(.green).font(.caption)
            }
        }
        .padding()
    }
}

