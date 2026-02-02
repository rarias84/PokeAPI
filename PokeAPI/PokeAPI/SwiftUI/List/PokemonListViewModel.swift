import SwiftUI

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [PokemonListItem] = []
    @Published var isLoading = false
    @Published private(set) var favorites: Set<Int> = []

    let repository: PokemonRepositoryProtocol
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func loadMoreIfNeeded(current item: PokemonListItem?) async {
        guard let item,
              item.id == pokemons.last?.id,
              canLoadMore,
              !isLoading else { return }

        await loadNextPage()
    }

    func loadNextPage() async {
        isLoading = true
        do {
            let results = try await repository.fetchPokemonPage(
                offset: offset,
                limit: limit
            )
            pokemons.append(contentsOf: results)
            offset += limit
            canLoadMore = !results.isEmpty
            await loadFavorites()
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    func refresh() async {
        isLoading = true
        offset = 0
        canLoadMore = true
        pokemons.removeAll()
        await loadNextPage()
        await loadFavorites()
    }

    func isFavorite(_ pokemon: PokemonListItem) -> Bool {
        favorites.contains(pokemon.id)
    }

    func toggleFavorite(_ pokemon: PokemonListItem) async {
        if await repository.isFavorite(pokemon) {
            await repository.removeFavorite(pokemon)
        } else {
            await repository.addFavorite(pokemon)
        }
        await loadFavorites()
    }

    func loadFavorites() async {
        favorites = await repository.favoriteIDs()
    }
}
