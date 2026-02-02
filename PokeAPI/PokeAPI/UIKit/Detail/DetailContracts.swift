@MainActor
protocol PokemonDetailViewProtocol: AnyObject {
    func render(_ pokemon: PokemonListItem,canGoPrevious: Bool, canGoNext: Bool)
    func renderDetail(_ detail: PokemonDetailUIModel)
}

@MainActor
protocol PokemonDetailInteractorProtocol {
    func loadDetail(for pokemon: PokemonListItem) async
}

@MainActor
protocol PokemonDetailInteractorOutput: AnyObject {
    func didLoadDetail(_ detail: PokemonDetailUIModel)
    func didFail(_ error: Error)
}
