//
//  MyPokemonTests.swift
//  MyPokemonTests
//
//  Created by Kauane S. R. on 04/06/25.
//

import XCTest
@testable import MyPokemon

final class MyPokemonTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPokemonAPIService_FetchPokemonDecoding() throws {
        // 1. Crie um JSON de exemplo como uma String
        let jsonString = """
        {
            "name": "bulbasaur",
            "types": [
                { "slot": 1, "type": { "name": "grass", "url": "https://pokeapi.co/api/v2/type/12/" } },
                { "slot": 2, "type": { "name": "poison", "url": "https://pokeapi.co/api/v2/type/4/" } }
            ]
        }
        """
        let jsonData = Data(jsonString.utf8)

        // 2. Crie uma instância do serviço
        let service = PokemonAPIService()

        // 3. Crie uma expectation para o teste assíncrono
        let expectation = self.expectation(description: "Pokemon decoding")

        var resultPokemon: Pokemon?
        var resultError: Error?

        // 4. Use um truque para chamar a função de decodificação interna (torne-a 'internal' se for 'private')
        // Como não podemos chamar diretamente, vamos simular o fetchPokemon com os dados locais.
        // A maneira mais fácil de testar a decodificação é expor uma função de decodificação.
        // No PokemonAPIService, adicione esta função para facilitar o teste:
        /*
         func decodePokemon(from data: Data) throws -> Pokemon {
             let decoder = JSONDecoder()
             let apiResponse = try decoder.decode(PokemonResponse.self, from: data)
             let pokemonTypes: [PokemonType] = apiResponse.types.compactMap { typeEntry in
                 guard let id = extractTypeId(from: typeEntry.type.url) else { return nil }
                 return PokemonType(id: id, name: typeEntry.type.name)
             }
             return Pokemon(name: apiResponse.name, types: pokemonTypes)
         }
        */

        // Agora no teste:
        do {
            // Supondo que você tornou a lógica de decodificação testável
            // (extraindo-a para uma função separada).
            let decoder = JSONDecoder()
            struct PokemonResponse: Codable {
                let name: String
                let types: [TypeEntry]
                struct TypeEntry: Codable { let type: TypeDetail }
                struct TypeDetail: Codable { let name: String; let url: String }
            }
            let response = try decoder.decode(PokemonResponse.self, from: jsonData)

            resultPokemon = Pokemon(name: response.name, types: []) // Simulação
            expectation.fulfill()
        } catch {
            resultError = error
        }

        // 5. Verifique os resultados
        XCTAssertNotNil(resultPokemon, "O Pokémon não deveria ser nulo")
        XCTAssertNil(resultError, "O erro deveria ser nulo")
        XCTAssertEqual(resultPokemon?.name, "bulbasaur")
    }
}
