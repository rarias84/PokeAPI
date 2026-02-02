import Foundation

final class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomeInteractorOutput?
    private let repository: PokemonRepositoryProtocol
    
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true
    private var cachedPokemons: [PokemonListItem] = []

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func loadNextPage() async {
        guard canLoadMore else {
            return
        }
        
        do {
            let pokemons = try await repository.fetchPokemonPage(offset: offset, limit: limit)
            offset += limit
            canLoadMore = !pokemons.isEmpty
            cachedPokemons.append(contentsOf: pokemons)
            await MainActor.run {
                presenter?.didFetchPokemons(pokemons)
            }
        } catch {
            await MainActor.run {
                presenter?.didFailWithError(error)
            }
        }
    }

    func refresh() async {
        offset = 0
        canLoadMore = true
        cachedPokemons.removeAll()
        await loadNextPage()
    }

    func toggleFavorite(_ pokemon: PokemonListItem) async {
        guard pokemon.id > 0 else { return }

        if await repository.isFavorite(pokemon) {
            await repository.removeFavorite(pokemon)
        } else {
            await repository.addFavorite(pokemon)
        }
    }
    
    func getFavoriteIDs() async -> Set<Int> {
        await repository.favoriteIDs()
    }
}
