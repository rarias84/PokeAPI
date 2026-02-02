import SwiftUI

struct PokemonCellView: View {
    let pokemon: PokemonListItem
    let isFavorite: Bool
    let onFavorite: () -> Void
    let namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 8) {
            Text(pokemon.name.capitalized)
                .font(.caption)
                .matchedGeometryEffect(id: pokemon.id, in: namespace)
            
            Button(action: onFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
