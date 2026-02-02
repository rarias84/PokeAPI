import UIKit

final class StatRowView: UIView {
    init(stat: PokemonStatUIModel) {
        super.init(frame: .zero)

        let nameLabel = UILabel()
        nameLabel.text = stat.name
        nameLabel.font = .systemFont(ofSize: 12)

        let valueLabel = UILabel()
        valueLabel.text = "\(stat.value)"
        valueLabel.font = .boldSystemFont(ofSize: 12)

        let progress = UIProgressView()
        progress.progress = Float(stat.value) / 100
        progress.tintColor = stat.color

        let hStack = UIStackView(arrangedSubviews: [
            nameLabel,
            valueLabel,
            progress
        ])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
