import UIKit

@MainActor
final class PokemonDetailViewController: UIViewController {
    private let idLabel = UILabel()
    private let pokemonImageView = UIImageView()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    private let aboutLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let baseStatsLabel = UILabel()
    private let statsView = PokemonStatsView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whiteCardView = UIView()

    private let presenter: PokemonDetailPresenter

    init(presenter: PokemonDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Navbar ID (right)
        idLabel.font = .systemFont(ofSize: 14, weight: .medium)
        idLabel.textColor = .white.withAlphaComponent(0.8)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: idLabel)

        // Image
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false

        // Chevrons
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        leftButton.tintColor = .white
        rightButton.tintColor = .white

        leftButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        leftButton.setContentHuggingPriority(.required, for: .horizontal)
        rightButton.setContentHuggingPriority(.required, for: .horizontal)

        // Image container (chevron - image - chevron)
        let imageContainer = UIStackView(arrangedSubviews: [
            leftButton,
            pokemonImageView,
            rightButton
        ])
        imageContainer.axis = .horizontal
        imageContainer.alignment = .center
        imageContainer.spacing = 12
        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        // Labels
        aboutLabel.text = "About"
        aboutLabel.font = .boldSystemFont(ofSize: 16)

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray

        baseStatsLabel.text = "Base Stats"
        baseStatsLabel.font = .boldSystemFont(ofSize: 16)

        // White card
        whiteCardView.backgroundColor = .white
        whiteCardView.layer.cornerRadius = 24
        whiteCardView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        whiteCardView.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [
            aboutLabel,
            descriptionLabel,
            baseStatsLabel,
            statsView
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 16
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        whiteCardView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: whiteCardView.topAnchor, constant: 24),
            infoStack.leadingAnchor.constraint(equalTo: whiteCardView.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: whiteCardView.trailingAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: whiteCardView.bottomAnchor, constant: -32)
        ])

        // Scroll
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let mainStack = UIStackView(arrangedSubviews: [
            imageContainer,
            whiteCardView
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            pokemonImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func prevTapped() {
        presenter.showPrevious()
    }

    @objc private func nextTapped() {
        presenter.showNext()
    }

    private func loadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageError", code: 0)
        }
        return image
    }
}

extension PokemonDetailViewController: PokemonDetailViewProtocol {
    func render(_ pokemon: PokemonListItem, canGoPrevious: Bool, canGoNext: Bool) {
        navigationItem.title = pokemon.name.capitalized

        let backItem = UIBarButtonItem(
            title: pokemon.name.capitalized,
            style: .plain,
            target: nil,
            action: nil
        )
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem

        leftButton.isHidden = !canGoPrevious
        rightButton.isHidden = !canGoNext
    }

    func renderDetail(_ detail: PokemonDetailUIModel) {
        idLabel.text = String(format: "#%03d", detail.id)

        if let url = detail.imageURL {
            Task {
                pokemonImageView.image = try? await loadImage(from: url)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = detail.color
        }

        descriptionLabel.text = detail.description
        statsView.configure(with: detail.stats)
    }
}
