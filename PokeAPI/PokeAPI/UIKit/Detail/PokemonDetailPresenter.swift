@MainActor
final class PokemonDetailPresenter {
    weak var view: PokemonDetailViewProtocol?

    private let pokemons: [PokemonListItem]
    private var index: Int
    private let interactor: PokemonDetailInteractorProtocol

    init(pokemons: [PokemonListItem], selectedIndex: Int, interactor: PokemonDetailInteractorProtocol) {
        self.pokemons = pokemons
        self.index = selectedIndex
        self.interactor = interactor
    }

    func viewDidLoad() {
        updateView()
        loadDetail()
    }

    func showPrevious() {
        guard index > 0 else {
            return
        }
        index -= 1
        updateView()
        loadDetail()
    }

    func showNext() {
        guard index < pokemons.count - 1 else {
            return
        }
        index += 1
        updateView()
        loadDetail()
    }
}

private extension PokemonDetailPresenter {
    func updateView() {
        view?.render(pokemons[index], canGoPrevious: index > 0, canGoNext: index < pokemons.count - 1)
    }

    func loadDetail() {
        Task {
            await interactor.loadDetail(for: pokemons[index])
        }
    }
}

extension PokemonDetailPresenter: PokemonDetailInteractorOutput {
    func didLoadDetail(_ detail: PokemonDetailUIModel) {
        view?.renderDetail(detail)
    }

    func didFail(_ error: Error) {
        print("Error loading pokemon detail:", error)
    }
}
