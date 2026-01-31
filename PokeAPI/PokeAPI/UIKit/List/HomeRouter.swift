import UIKit

@MainActor
final class HomeRouter {
    weak var viewController: UIViewController?

    func navigateToDetail(pokemon: PokemonListItem) {
//        let detailVC = PokemonDetailRouter.createModule(pokemon: pokemon)
//        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
