import Foundation

// /pokemon
struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: URL?

    var id: Int {
       guard let url else { return 0 }

       let components = url.pathComponents
       if let numeric = components.reversed().first(where: { Int($0) != nil }),
          let id = Int(numeric) {
           return id
       }

       return 0
   }
    
    var imageURL: URL? {
        guard id > 0 else { return nil }
        return URL(
            string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        )
    }
}
