import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    @State private var searchText: String = ""
    @State private var showFavoritesOnly: Bool = false

    @Namespace private var animationNamespace
    @State private var selectedPokemon: PokemonListItem?
    @State private var selectedIndex: Int = 0
    @State private var showDetail: Bool = false

    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var filteredPokemons: [PokemonListItem] {
        let searched = viewModel.pokemons.filter { pokemon in
            searchText.isEmpty || pokemon.name.localizedCaseInsensitiveContains(searchText)
        }
        let filtered = searched.filter { pokemon in
            !showFavoritesOnly || viewModel.isFavorite(pokemon)
        }
        return filtered
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(filteredPokemons.indices, id: \.self) { index in
                            let pokemon = filteredPokemons[index]
                            PokemonCellView(
                                pokemon: pokemon,
                                isFavorite: viewModel.isFavorite(pokemon),
                                onFavorite: { Task { await viewModel.toggleFavorite(pokemon) } },
                                namespace: animationNamespace
                            )
                            .onTapGesture {
                                selectedIndex = index
                                selectedPokemon = pokemon
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                    showDetail = true
                                }
                            }
                        }
                    }
                    .padding(8)
                }
                if let pokemon = selectedPokemon, showDetail {
                    PokemonDetailZoomView(
                        context: PokemonDetailNavigationContext(
                            pokemons: filteredPokemons,
                            selectedIndex: selectedIndex
                        ),
                        repository: viewModel.repository,
                        namespace: animationNamespace,
                        isPresented: $showDetail
                    )
                    .zIndex(1)
                }
            }
            .navigationTitle("Pokémon")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar Pokémon")
            .task {
                if viewModel.pokemons.isEmpty {
                    await viewModel.loadNextPage()
                }
            }
        }
    }
}
