//
//  UserAuthViewModel.swift
//  MyPokemon
//
//  Created by user276516 on 6/15/25.
//
import Foundation
import SwiftData

@MainActor
class UserAuthViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var loginError: String? = nil
    
    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func cadastrar(userName: String, email: String, password: String) -> Bool {
        guard let modelContext = modelContext else { return false }

        let exists = (try? modelContext.fetch(FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )))?.first != nil

        guard !exists else {
            loginError = "Usuário com esse e-mail já existe."
            return false
        }

        let user = User(userName: userName, email: email, password: password)
        modelContext.insert(user)
        try? modelContext.save()
        currentUser = user
        return true
    }

    func login(email: String, password: String) -> Bool {
        guard let modelContext = modelContext else { return false }

        do {
            let result = try modelContext.fetch(FetchDescriptor<User>(
                predicate: #Predicate { $0.email == email && $0.password == password }
            ))
            if let user = result.first {
                currentUser = user
                return true
            } else {
                loginError = "Email ou senha incorretos."
                return false
            }
        } catch {
            loginError = "Erro ao autenticar."
            return false
        }
    }

    func logout() {
        currentUser = nil
    }
}
