import SwiftUI
import UIKit

@MainActor
enum PokemonListFactory {
    static func createModule() -> UIViewController {
        let service = PokemonService()
        let favoritesManager = FavoritesManager()
        let repository = PokemonRepository(service: service, favorites: favoritesManager)
        let viewModel = PokemonListViewModel(repository: repository)
        let view = PokemonListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        return vc
    }
}
