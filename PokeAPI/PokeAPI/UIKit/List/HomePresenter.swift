@MainActor
protocol HomeInteractorOutput: AnyObject {
    func didFetchPokemons(_ pokemons: [PokemonListItem])
    func didFailWithError(_ error: Error)
}

@MainActor
protocol HomePresenterProtocol: AnyObject {
    var pokemons: [PokemonListItem] { get }
    var isShowingFavorites: Bool { get }

    func filterPokemons(query: String)
    func loadNextPage()
    func didSelectPokemon(_ pokemon: PokemonListItem)
    func refresh()
    func showFavorites()
    func showAllPokemons()
    func toggleFavorite(for pokemon: PokemonListItem)
    func isFavorite(_ pokemon: PokemonListItem) -> Bool
}

@MainActor
final class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouter

    private(set) var pokemons: [PokemonListItem] = []
    private var allPokemons: [PokemonListItem] = []
    private var showingFavorites = false
    private var favoriteNames: Set<String> = []

    var isShowingFavorites: Bool { showingFavorites }

    init(interactor: HomeInteractorProtocol, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func syncFavorites() async {
        let favorites = await interactor.getFavorites()
        favoriteNames = Set(favorites.map { $0.name })
    }
}

extension HomePresenter: HomePresenterProtocol {
    func loadNextPage() {
        Task {
            await syncFavorites()
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

    func didSelectPokemon(_ pokemon: PokemonListItem) {
        router.navigateToDetail(pokemon: pokemon)
    }

    func filterPokemons(query: String) {
        if query.isEmpty {
            pokemons = allPokemons
        } else {
            pokemons = allPokemons.filter { $0.name.lowercased().contains(query) }
        }
        view?.reloadData()
    }

    func showAllPokemons() {
        showingFavorites = false
        Task {
            await syncFavorites()
            pokemons = allPokemons
            view?.reloadData()
        }
    }

    func showFavorites() {
        showingFavorites = true
        Task {
            let favorites = await interactor.getFavorites()
            pokemons = favorites
            favoriteNames = Set(favorites.map { $0.name })
            view?.reloadData()
        }
    }

    func isFavorite(_ pokemon: PokemonListItem) -> Bool {
        favoriteNames.contains(pokemon.name)
    }
    
    func toggleFavorite(for pokemon: PokemonListItem) {
        Task {
            await interactor.toggleFavorite(pokemon)
            let favorites = await interactor.getFavorites()
            favoriteNames = Set(favorites.map { $0.name })

            if showingFavorites {
                pokemons = favorites
            } else {
                pokemons = allPokemons
            }
            view?.reloadData()
        }
    }
}

extension HomePresenter: HomeInteractorOutput {
    func didFetchPokemons(_ pokemons: [PokemonListItem]) {
        allPokemons.append(contentsOf: pokemons)
        if !showingFavorites {
            self.pokemons = allPokemons
            view?.reloadData()
        }
    }

    func didFailWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}
