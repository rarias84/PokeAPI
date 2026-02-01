import UIKit

@MainActor
protocol HomeViewControllerProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
}

@MainActor
final class HomeViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let itemWidth = (UIScreen.main.bounds.width - spacing * 4) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 32)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(PokemonGridCell.self, forCellWithReuseIdentifier: "PokemonGridCell")
        return cv
    }()
    
    private let segmentControl = UISegmentedControl(items: ["Todos", "Favoritos"])
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private var presenter: HomePresenterProtocol
    
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        presenter.loadNextPage()
    }

    private func setupUI() {
        title = "Pokémon"
        view.backgroundColor = .white

        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        navigationItem.titleView = segmentControl
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Pokémon"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.addSubview(collectionView)

        // Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func didPullToRefresh() {
        guard presenter.isShowingFavorites == false else {
            refreshControl.endRefreshing()
            return
        }
        presenter.refresh()
    }
    
    @objc private func didChangeSegment() {
        if segmentControl.selectedSegmentIndex == 0 {
            refreshControl.isEnabled = true
            presenter.showAllPokemons()
        } else {
            refreshControl.isEnabled = false
            refreshControl.endRefreshing()
            presenter.showFavorites()
        }
    }
}

@MainActor
extension HomeViewController: HomeViewControllerProtocol {
    func reloadData() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
        footerSpinner.stopAnimating()
    }

    func showError(_ message: String) {
        collectionView.refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = presenter.pokemons[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonGridCell", for: indexPath) as? PokemonGridCell else {
            return UICollectionViewCell()
        }
        cell.configure(name: pokemon.name, isFavorite: presenter.isFavorite(pokemon)) { [weak self] in
            self?.presenter.toggleFavorite(for: pokemon)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let pokemon = presenter.pokemons[indexPath.row]
        presenter.didSelectPokemon(pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard presenter.isShowingFavorites == false else { return }
        if indexPath.row == presenter.pokemons.count - 1 {
            footerSpinner.startAnimating()
            presenter.loadNextPage()
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        presenter.filterPokemons(query: query)
    }
}

final class PokemonGridCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12

        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textAlignment = .center

        favoriteButton.setTitle("★", for: .normal)
        favoriteButton.setTitleColor(.systemYellow, for: .normal)

        let stack = UIStackView(arrangedSubviews: [nameLabel, favoriteButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(name: String, isFavorite: Bool, onFavorite: @escaping () -> Void) {
        nameLabel.text = name.capitalized
        favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        favoriteButton.addAction(UIAction { _ in onFavorite() }, for: .touchUpInside)
    }
}
