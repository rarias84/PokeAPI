import Foundation

actor FavoritesManager {
    private let defaults: UserDefaults
    private let key = "favorite_pokemon_ids"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func add(id: Int) async {
        var ids = loadIDs()
        ids.insert(id)
        save(ids)
    }

    func remove(id: Int) async {
        var ids = loadIDs()
        ids.remove(id)
        save(ids)
    }

    func isFavorite(id: Int) async -> Bool {
        loadIDs().contains(id)
    }

    func allIDs() async -> Set<Int> {
        loadIDs()
    }
}

// MARK: - helpers
private extension FavoritesManager {
    func loadIDs() -> Set<Int> {
        guard let data = defaults.data(forKey: key), let ids = try? JSONDecoder().decode(Set<Int>.self, from: data) else {
            return []
        }
        return ids
    }

    func save(_ ids: Set<Int>) {
        guard let data = try? JSONEncoder().encode(ids) else {
            return
        }
        defaults.set(data, forKey: key)
    }
}
