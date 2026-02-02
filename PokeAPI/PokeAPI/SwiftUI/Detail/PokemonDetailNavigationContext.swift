struct PokemonDetailNavigationContext: Identifiable, Hashable {
    let id: Int
    let pokemons: [PokemonListItem]
    let selectedIndex: Int

    init(pokemons: [PokemonListItem], selectedIndex: Int) {
        self.pokemons = pokemons
        self.selectedIndex = selectedIndex
        self.id = pokemons[selectedIndex].id
    }

    static func == (
        lhs: PokemonDetailNavigationContext,
        rhs: PokemonDetailNavigationContext
    ) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
