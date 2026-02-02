import UIKit

@MainActor
final class HomeRouter {
    weak var viewController: UIViewController?

    func navigateToDetail(pokemons: [PokemonListItem], selectedIndex: Int) {
        let service = PokemonService()
        let favoritesManager = FavoritesManager()
        let repository = PokemonRepository(service: service, favorites: favoritesManager)
        let interactor = PokemonDetailInteractor(repository: repository)
        let presenter = PokemonDetailPresenter(pokemons: pokemons, selectedIndex: selectedIndex, interactor: interactor)
        let vc = PokemonDetailViewController(presenter: presenter)

        presenter.view = vc
        interactor.presenter = presenter

        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
