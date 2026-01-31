import Foundation

enum PokemonAPI {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2")!

    static func pokemonList(offset: Int, limit: Int) -> URL {
        baseURL
            .appendingPathComponent("pokemon")
            .appending(queryItems: [
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)")
            ])
    }

    static func pokemonDetail(name: String) -> URL {
        baseURL.appendingPathComponent("pokemon/\(name)")
    }
}

private extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        return components.url!
    }
}
