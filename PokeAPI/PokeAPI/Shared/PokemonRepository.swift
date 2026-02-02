import UIKit

protocol PokemonRepositoryProtocol {
    func fetchPokemonPage(offset: Int, limit: Int) async throws -> [PokemonListItem]
    func fetchPokemonDetail(name: String) async throws -> Pokemon
    func addFavorite(_ pokemon: PokemonListItem) async
    func removeFavorite(_ pokemon: PokemonListItem) async
    func isFavorite(_ pokemon: PokemonListItem) async -> Bool
    func fetchPokemonFullDetail(name: String) async throws -> PokemonDetailUIModel
    func favoriteIDs() async -> Set<Int>
}

final class PokemonRepository: PokemonRepositoryProtocol {
    private let service: PokemonServiceProtocol
    private let favorites: FavoritesManager

    init(service: PokemonServiceProtocol, favorites: FavoritesManager) {
        self.service = service
        self.favorites = favorites
    }

    func fetchPokemonPage(offset: Int, limit: Int) async throws -> [PokemonListItem] {
        let response = try await service.fetchPokemonPage(offset: offset, limit: limit)
        return response.results
    }

    func fetchPokemonDetail(name: String) async throws -> Pokemon {
        try await service.fetchPokemonDetail(name: name)
    }
    
    func fetchPokemonFullDetail(name: String) async throws -> PokemonDetailUIModel {
       async let pokemon = service.fetchPokemonDetail(name: name)
       async let species = service.fetchPokemonSpecies(name: name)

       let (p, s) = try await (pokemon, species)

       let description = s.flavorTextEntries
           .first { $0.language.name == "es" }?
           .flavorText
           .replacingOccurrences(of: "\n", with: " ")

       return PokemonDetailUIModel(
           id: p.id,
           name: p.name.capitalized,
           imageURL: p.sprites.other?.officialArtwork?.frontDefault ?? p.sprites.frontDefault,
           types: p.types.map { $0.type.name },
           stats: p.stats.map {
               PokemonStatUIModel(
                name: $0.stat.name,
                value: $0.baseStat,
                color: .pokemonColor(s.color.name)
               )
           },
           height: p.height,
           weight: p.weight,
           color: .pokemonColor(s.color.name),
           description: description
       )
   }

    func addFavorite(_ pokemon: PokemonListItem) async {
        await favorites.add(id: pokemon.id)
    }

    func removeFavorite(_ pokemon: PokemonListItem) async {
        await favorites.remove(id: pokemon.id)
    }

    func isFavorite(_ pokemon: PokemonListItem) async -> Bool {
        await favorites.isFavorite(id: pokemon.id)
    }

    func favoriteIDs() async -> Set<Int> {
        await favorites.allIDs()
    }
}
