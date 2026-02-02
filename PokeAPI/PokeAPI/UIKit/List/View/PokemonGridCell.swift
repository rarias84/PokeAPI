import UIKit

final class PokemonGridCell: UICollectionViewCell {
    private let idLabel = UILabel()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 5

        idLabel.font = .systemFont(ofSize: 12, weight: .medium)
        idLabel.textColor = .systemGray
        idLabel.textAlignment = .left

        imageView.contentMode = .scaleAspectFit

        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.textAlignment = .center

        favoriteButton.setTitle("★", for: .normal)
        
        let topStack = UIStackView(arrangedSubviews: [idLabel, UIView(), favoriteButton])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.distribution = .fill
        
        let stack = UIStackView(arrangedSubviews: [
            topStack,
            imageView,
            nameLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            imageView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    func configure(with pokemon: PokemonListItem, isFavorite: Bool, onFavorite: @escaping () -> Void) {
        idLabel.text = "#\(pokemon.id)"
        nameLabel.text = pokemon.name.capitalized
        
        favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        favoriteButton.setTitleColor(isFavorite ? .systemYellow : .systemGray, for: .normal)
        favoriteButton.addAction(UIAction { _ in onFavorite() }, for: .touchUpInside)

        if let url = pokemon.imageURL {
            Task {
                do {
                    let image = try await loadImage(from: url)
                    imageView.image = image
                } catch {
                    print("Error loading image: \(error)")
                    imageView.image = UIImage(systemName: "photo")
                }
            }
        } else {
            imageView.image = nil
        }
    }
    
    // TODO: - move to a helper
    private func loadImage(from url: URL) async throws -> UIImage {
       let (data, _) = try await URLSession.shared.data(from: url)
       guard let image = UIImage(data: data) else {
           throw NSError(domain: "ImageLoadingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"])
       }
       return image
   }
}
