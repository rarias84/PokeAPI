import SwiftUI

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var detail: PokemonDetailUIModel?

    private let pokemons: [PokemonListItem]
    private let repository: PokemonRepositoryProtocol
    private var index: Int

    init(context: PokemonDetailNavigationContext, repository: PokemonRepositoryProtocol) {
        self.pokemons = context.pokemons
        self.index = context.selectedIndex
        self.repository = repository
    }

    var currentPokemon: PokemonListItem? {
        guard pokemons.indices.contains(index) else { return nil }
        return pokemons[index]
    }

    var canGoPrevious: Bool { index > 0 }
    var canGoNext: Bool { index < pokemons.count - 1 }

    func onAppear() {
        loadDetail()
    }

    func showPrevious() {
        guard canGoPrevious else { return }
        index -= 1
        loadDetail()
    }

    func showNext() {
        guard canGoNext else { return }
        index += 1
        loadDetail()
    }

    private func loadDetail() {
        guard let pokemon = currentPokemon else { return }

        Task {
            do {
                detail = try await repository.fetchPokemonFullDetail(
                    name: pokemon.name
                )
            } catch {
                print("Error loading detail:", error)
            }
        }
    }
}
