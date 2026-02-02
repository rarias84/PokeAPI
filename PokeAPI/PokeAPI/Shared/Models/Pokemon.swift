import Foundation

// /pokemon/{id}
struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonTypeSlot]
    let stats: [PokemonStat]
    let moves: [PokemonMove]
}

struct Sprites: Codable {
    let frontDefault: URL?
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: URL?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonStat: Codable {
    let baseStat: Int
    let stat: Stat

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct Stat: Codable {
    let name: String
}

struct PokemonMove: Codable {
    let move: Move
}

struct Move: Codable {
    let name: String
}
