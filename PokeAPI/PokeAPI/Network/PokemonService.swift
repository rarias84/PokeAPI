import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> PokemonListResponse
    func fetchPokemonDetail(name: String) async throws -> Pokemon
    func fetchPokemonSpecies(name: String) async throws -> PokemonSpecies
}

struct PokemonService: PokemonServiceProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> PokemonListResponse {
        let url = PokemonAPI.pokemonList(offset: offset, limit: limit)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonListResponse.self, from: data)
    }

    func fetchPokemonDetail(name: String) async throws -> Pokemon {
        let url = PokemonAPI.pokemonDetail(name: name)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }

    func fetchPokemonSpecies(name: String) async throws -> PokemonSpecies {
        let url = PokemonAPI.pokemonSpecies(name: name)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonSpecies.self, from: data)
    }
}
