import UIKit

final class PokemonCell: UITableViewCell {
    private let favoriteButton = UIButton(type: .system)
    private var onToggleFavorite: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = favoriteButton

        favoriteButton.setTitleColor(.systemYellow, for: .normal)
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 20)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with pokemonName: String, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        textLabel?.text = pokemonName.capitalized
        let star = isFavorite ? "★" : "☆"
        favoriteButton.setTitle(star, for: .normal)
        self.onToggleFavorite = onToggleFavorite
    }

    @objc private func didTapFavorite() {
        onToggleFavorite?()
    }
}
