@MainActor
final class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouter

    private(set) var pokemons: [PokemonListItem] = []
    private var allPokemons: [PokemonListItem] = []
    private var showingFavorites = false
    private var favoriteIDs: Set<Int> = []

    private var currentSearchQuery: String = ""
    var isShowingFavorites: Bool { showingFavorites }

    init(interactor: HomeInteractorProtocol, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func syncFavorites() async {
        favoriteIDs = await interactor.getFavoriteIDs()
    }
    
    private func applyFilters() {
        var list = allPokemons

        if showingFavorites {
            list = list.filter { favoriteIDs.contains($0.id) }
        }

        if !currentSearchQuery.isEmpty {
            list = list.filter { $0.name.lowercased().contains(currentSearchQuery.lowercased()) }
        }

        pokemons = list
    }

    private func rebuildVisibleList() {
        if showingFavorites {
            pokemons = allPokemons.filter { favoriteIDs.contains($0.id) }
        } else {
            pokemons = allPokemons
        }
    }
}

extension HomePresenter: HomePresenterProtocol {
    func loadNextPage() {
        Task {
            await interactor.loadNextPage()
        }
    }

    func refresh() {
        pokemons.removeAll()
        allPokemons.removeAll()
        view?.reloadData()
        
        Task {
            await interactor.refresh()
        }
    }

    func didSelectPokemon(at index: Int) {
        router.navigateToDetail(
            pokemons: pokemons,
            selectedIndex: index
        )
    }

    func filterPokemons(query: String) {
        currentSearchQuery = query
        applyFilters()
        view?.reloadData()
    }

    func showAllPokemons() {
        showingFavorites = false
        Task {
            await syncFavorites()
            applyFilters()
            view?.reloadData()
        }
    }

    func showFavorites() {
        showingFavorites = true
        Task {
            await syncFavorites()
            applyFilters()
            view?.reloadData()
        }
    }

    func isFavorite(_ pokemon: PokemonListItem) -> Bool {
        favoriteIDs.contains(pokemon.id)
    }
    
    func toggleFavorite(for pokemon: PokemonListItem) {
        Task {
            await interactor.toggleFavorite(pokemon)
            favoriteIDs = await interactor.getFavoriteIDs()

            if showingFavorites {
                if let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) {
                    pokemons.remove(at: index)
                    view?.deleteItem(at: index)
                }
            } else {
                if let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) {
                    view?.reloadItem(at: index)
                }
            }
        }
    }
}

extension HomePresenter: HomeInteractorOutput {
    func didFetchPokemons(_ pokemons: [PokemonListItem]) {
        Task {
            await syncFavorites()

            allPokemons.append(contentsOf: pokemons)
            applyFilters()

            view?.reloadData()
        }
    }

    func didFailWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}
