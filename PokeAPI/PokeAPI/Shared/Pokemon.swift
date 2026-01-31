struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable, Identifiable {
    let name: String
    let url: String?

    var id: String { name }
}

struct PokemonDetail: Decodable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [AbilitySlot]
    let stats: [StatSlot]
}

struct AbilitySlot: Decodable {
    let ability: NamedAPIResource
}

struct StatSlot: Decodable {
    let base_stat: Int
    let stat: NamedAPIResource
}

struct NamedAPIResource: Decodable {
    let name: String
}
