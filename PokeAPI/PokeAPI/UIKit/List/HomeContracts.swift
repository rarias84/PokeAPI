protocol HomeInteractorProtocol {
    func loadNextPage() async
    func refresh() async
    func toggleFavorite(_ pokemon: PokemonListItem) async
    func getFavoriteIDs() async -> Set<Int>
}

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
    func didSelectPokemon(at index: Int)
    func refresh()
    func showFavorites()
    func showAllPokemons()
    func toggleFavorite(for pokemon: PokemonListItem)
    func isFavorite(_ pokemon: PokemonListItem) -> Bool
}

@MainActor
protocol HomeViewControllerProtocol: AnyObject {
    func reloadItem(at index: Int)
    func deleteItem(at index: Int)
    func reloadData()
    func showError(_ message: String)
}
