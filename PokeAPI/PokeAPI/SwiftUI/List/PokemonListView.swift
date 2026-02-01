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

            ScrollView {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(filteredPokemons) { pokemon in
                        VStack(spacing: 8) {
                            Text(pokemon.name.capitalized)
                                .font(.caption)

                            Button {
                                Task { await viewModel.toggleFavorite(pokemon) }
                            } label: {
                                Image(systemName: viewModel.isFavorite(pokemon) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .task {
                            if !showFavoritesOnly {
                                await viewModel.loadMoreIfNeeded(current: pokemon)
                            }
                        }
                    }
                }
                .padding(8)
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
