// /pokemon-species/{id}
struct PokemonSpecies: Codable {
    let id: Int
    let name: String
    let color: PokemonColor
    let flavorTextEntries: [FlavorTextEntry]
    let genera: [Genus]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case flavorTextEntries = "flavor_text_entries"
        case genera
    }
}

struct PokemonColor: Codable {
    let name: String
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Codable {
    let name: String
}

struct Genus: Codable {
    let genus: String
    let language: Language
}
