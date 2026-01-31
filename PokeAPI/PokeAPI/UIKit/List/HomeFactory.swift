import UIKit

@MainActor
enum HomeFactory {
    static func createModule() -> UIViewController {
        let service = PokemonService()
        let favoritesManager = FavoritesManager()
        let repository = PokemonRepository(service: service, favorites: favoritesManager)
        let interactor = HomeInteractor(repository: repository)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        let view = HomeViewController(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
