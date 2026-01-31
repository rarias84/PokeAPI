import UIKit

@MainActor
protocol HomeViewControllerProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
}

@MainActor
final class HomeViewController: UIViewController {
    private let tableView = UITableView()
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

        tableView.tableFooterView = footerSpinner
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.addSubview(tableView)

        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        tableView.reloadData()
        refreshControl.endRefreshing()
        footerSpinner.stopAnimating()
    }

    func showError(_ message: String) {
        tableView.refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.pokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let pokemon = presenter.pokemons[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        cell.configure(with: pokemon.name, isFavorite: presenter.isFavorite(pokemon)) { [weak self] in
            self?.presenter.toggleFavorite(for: pokemon)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemon = presenter.pokemons[indexPath.row]
        presenter.didSelectPokemon(pokemon)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
