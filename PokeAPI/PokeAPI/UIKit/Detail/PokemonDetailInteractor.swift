final class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    weak var presenter: PokemonDetailInteractorOutput?
    private let repository: PokemonRepositoryProtocol
    private var cache: [String: PokemonDetailUIModel] = [:]

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func loadDetail(for pokemon: PokemonListItem) async {
        if let cached = cache[pokemon.name] {
            presenter?.didLoadDetail(cached)
            return
        }

        do {
            let detail = try await repository.fetchPokemonFullDetail(
                name: pokemon.name
            )
            cache[pokemon.name] = detail
            presenter?.didLoadDetail(detail)
        } catch {
            presenter?.didFail(error)
        }
    }
}
