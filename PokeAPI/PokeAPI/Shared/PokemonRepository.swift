protocol PokemonRepositoryProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> [PokemonListItem]
    func fetchPokemonDetail(name: String) async throws -> PokemonDetail
    func addFavorite(_ pokemon: PokemonListItem) async
    func removeFavorite(_ pokemon: PokemonListItem) async
    func isFavorite(_ pokemon: PokemonListItem) async -> Bool
    func allFavorites() async -> [PokemonListItem]
}

final class PokemonRepository: PokemonRepositoryProtocol {
    private let service: PokemonServiceProtocol
    private let favorites: FavoritesManager

    init(service: PokemonServiceProtocol, favorites: FavoritesManager) {
        self.service = service
        self.favorites = favorites
    }

    func fetchPokemonPage(offset: Int, limit: Int) async throws -> [PokemonListItem] {
        let response = try await service.fetchPokemonPage(offset: offset, limit: limit)
        return response.results
    }

    func fetchPokemonDetail(name: String) async throws -> PokemonDetail {
        try await service.fetchPokemonDetail(name: name)
    }

    func addFavorite(_ pokemon: PokemonListItem) async {
        await favorites.add(pokemon)
    }

    func removeFavorite(_ pokemon: PokemonListItem) async {
        await favorites.remove(pokemon)
    }

    func isFavorite(_ pokemon: PokemonListItem) async -> Bool {
        await favorites.isFavorite(pokemon)
    }

    func allFavorites() async -> [PokemonListItem] {
        await favorites.allFavorites()
    }
}
