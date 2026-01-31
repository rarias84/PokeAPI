import Foundation

// MARK: - FavoritesManager
actor FavoritesManager {
    private let defaults: UserDefaults
    private let key = "favorite_pokemons"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func add(_ pokemon: PokemonListItem) async {
        var names = favoriteNames()
        if !names.contains(pokemon.name) {
            names.append(pokemon.name)
            save(names: names)
        }
    }

    func remove(_ pokemon: PokemonListItem) async {
        var names = favoriteNames()
        if let idx = names.firstIndex(of: pokemon.name) {
            names.remove(at: idx)
            save(names: names)
        }
    }

    func isFavorite(_ pokemon: PokemonListItem) async -> Bool {
        favoriteNames().contains(pokemon.name)
    }

    func allFavorites() async -> [PokemonListItem] {
        favoriteNames().map { PokemonListItem(name: $0, url: nil) }
    }
}

// MARK: - Helpers
private extension FavoritesManager {
    func favoriteNames() -> [String] {
        defaults.stringArray(forKey: key) ?? []
    }

    func save(names: [String]) {
        defaults.set(names, forKey: key)
    }
}
