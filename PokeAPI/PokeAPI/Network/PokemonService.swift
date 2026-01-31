import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> PokemonListResponse
    func fetchPokemonDetail(name: String) async throws -> PokemonDetail
}

struct PokemonService: PokemonServiceProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> PokemonListResponse {
        let url = PokemonAPI.pokemonList(offset: offset, limit: limit)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonListResponse.self, from: data)
    }

    func fetchPokemonDetail(name: String) async throws -> PokemonDetail {
        let url = PokemonAPI.pokemonDetail(name: name)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
}
