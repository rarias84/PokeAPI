import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    @State private var searchText: String = ""
    @State private var showFavoritesOnly: Bool = false

    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var filteredPokemons: [PokemonListItem] {
        viewModel.pokemons.filter { pokemon in
            let matchesSearch = searchText.isEmpty || pokemon.name.localizedCaseInsensitiveContains(searchText)
            let matchesFavorite = !showFavoritesOnly || viewModel.isFavorite(pokemon)
            return matchesSearch && matchesFavorite
        }
    }

    var body: some View {
        VStack {
            HStack {
                Picker("Filter", selection: $showFavoritesOnly) {
                    Text("Todos").tag(false)
                    Text("Favoritos").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.horizontal)

            List(filteredPokemons) { pokemon in
                HStack {
                    Text(pokemon.name.capitalized)
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.toggleFavorite(pokemon)
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite(pokemon) ? "star.fill" : "star")
                            .foregroundColor(viewModel.isFavorite(pokemon) ? .yellow : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .task {
                    if !showFavoritesOnly {
                        await viewModel.loadMoreIfNeeded(current: pokemon)
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                if !showFavoritesOnly {
                    await viewModel.refresh()
                } else {
                    // ensure spinner is hidden
                    viewModel.isLoading = false
                }
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
