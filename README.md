# 📱 MyPokemonn App

Um aplicativo iOS criado em SwiftUI com persistência de dados via SwiftData, que permite aos usuários visualizar, favoritar e explorar detalhes dos Pokémons consumidos diretamente da PokéAPI.

---

## 🧠 Alunos

Ana Julia Rocha Cezanoski
Kauane Santana
Lucas Nascimento

---

## 🔍 Descrição Geral do Aplicativo

O **MyPokemonn** é um app de catálogo e favoritos de Pokémons. Ele permite:

* Listar todos os Pokémons da PokéAPI
* Visualizar detalhes como tipo, habilidades, altura, peso e stats
* Favoritar Pokémons e acessá-los na aba de favoritos
* Criar conta e realizar login usando autenticação local (SwiftData)

---

## 🧩 Escolha da API

**PokéAPI** foi escolhida por ser uma API pública, estável e completa com dados atualizados de todos os Pokémons.

### Justificativa:

* Possui endpoints bem estruturados
* Suporte a dados como tipos, stats, imagens, habilidades e mais
* Ideal para aprendizado com requisições e decodificação JSON

### Como usar:

* Endpoint principal: `https://pokeapi.co/api/v2/pokemon`
* A busca por detalhes usa: `https://pokeapi.co/api/v2/pokemon/{nome}`

### Dados utilizados:

* `name`, `id`, `sprites.front_default`, `types`, `abilities`, `height`, `weight`, `stats`

---

## 🏗️ Arquitetura do Aplicativo

O app segue o padrão **MVVM (Model - View - ViewModel)**:

```
PokéAPI ---> Service Layer (PokemonAPIService)
          ↳ Decodifica dados JSON e transforma em modelos Swift

Model Layer:
- Pokemon.swift
- PokemonInfo.swift
- PokemonType.swift
- Stat.swift
- User.swift

ViewModel Layer:
- PokemonViewModel.swift (manipula lista e favoritos)
- UserAuthViewModel.swift (autenticação e controle do usuário)

View Layer:
- ContentView
- PokemonListView
- PokemonDetailView
- FavoritesView
- LoginView
- CadastroView
```

---

## 💾 Implementação do SwiftData

O SwiftData foi utilizado para persistir:

* Pokémons favoritados
* Usuários registrados

### Entidades definidas:

* `Pokemon`
* * `PokemonInfo`
* `User`
* `PokemonType`
* `Stat`

### Autenticação:

* O usuário cria uma conta com nome, e-mail e senha
* Os dados são persistidos localmente com SwiftData
* Após o login, o app navega para a tela principal usando o `currentUser`

### Busca e salvamento:

* ModelContext é injetado em todas as Views
* FetchDescriptors realizam buscas por nome/email
* Inserções e remoções são feitas com `.insert()` e `.delete()`

---

## 🎨 Design Tokens

O projeto define tokens de design em `DesignTokens.swift`:

```swift
enum AppColors {
    static let primaryBackground = Color("PrimaryBackgroundColor")
    static let primaryText = Color.primary
    static let favoriteHeart = Color.red
}

enum AppFonts {
    static let title = Font.largeTitle.bold()
    static let body = Font.body
}
```

Esses tokens garantem consistência visual entre as telas.

---

## ✨ Item de Criatividade

**Background personalizado por tipo de Pokémon**:

* Cada tipo (`grass`, `fire`, `water`, etc.) recebe um fundo diferente via `backgroundImageFor(typeName:)`
* Isso melhora a imersão visual do usuário na tela de detalhes

**Cores personalizadas por tipo**:

* Cores foram definidas manualmente para cada tipo
* Ajudam na rápida identificação dos tipos do Pokémon

---

## 📚 Bibliotecas de Terceiros

Este projeto não utiliza bibliotecas externas. Todas as funcionalidades são feitas com:

* SwiftUI
* SwiftData (Framework nativo de persistência)
* Combine

---

## ✅ Status do Projeto

* [x] Listagem de Pokémons com dados da API
* [x] Tela de detalhes
* [x] Sistema de favoritos
* [x] Autenticação com SwiftData
* [x] Design Tokens aplicados
* [x] Logout do usuário
* [x] Persistência total local

      
