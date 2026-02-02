import UIKit

struct PokemonDetailUIModel {
    let id: Int
    let name: String
    let imageURL: URL?
    let types: [String]
    let stats: [PokemonStatUIModel]
    let height: Int
    let weight: Int
    let color: UIColor
    let description: String?
}

struct PokemonStatUIModel {
    let name: String
    let value: Int
    let color: UIColor
}
