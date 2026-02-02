import SwiftUI

struct PokemonDetailZoomView: View {
    let context: PokemonDetailNavigationContext
    let repository: PokemonRepositoryProtocol
    let namespace: Namespace.ID

    @Binding var isPresented: Bool

    @StateObject private var viewModel: PokemonDetailViewModel

    init(
        context: PokemonDetailNavigationContext,
        repository: PokemonRepositoryProtocol,
        namespace: Namespace.ID,
        isPresented: Binding<Bool>
    ) {
        self.context = context
        self.repository = repository
        self.namespace = namespace
        self._isPresented = isPresented

        _viewModel = StateObject(
            wrappedValue: PokemonDetailViewModel(
                context: context,
                repository: repository
            )
        )
    }

    var body: some View {
        ZStack {
            Color(viewModel.detail?.color ?? .systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 64)

                HStack {
                    Button {
                        viewModel.showPrevious()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    .opacity(viewModel.canGoPrevious ? 1 : 0)

                    Spacer()

                    Text(viewModel.currentPokemon?.name.capitalized ?? "")
                        .font(.system(size: 32, weight: .bold))
                        .matchedGeometryEffect(id: viewModel.currentPokemon?.id, in: namespace)

                    Spacer()

                    Button {
                        viewModel.showNext()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                    .opacity(viewModel.canGoNext ? 1 : 0)
                }
                .padding(.horizontal, 24)

                Spacer()

                if let detail = viewModel.detail {
                    VStack(spacing: 12) {
                        Text("Height: \(detail.height)")
                        Text("Weight: \(detail.weight)")
                    }
                    .font(.headline)
                } else {
                    ProgressView()
                }

                Spacer()
            }

            VStack {
                HStack {
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
