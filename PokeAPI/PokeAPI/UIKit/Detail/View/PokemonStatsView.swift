import UIKit

final class PokemonStatsView: UIView {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with stats: [PokemonStatUIModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for stat in stats {
            let row = StatRowView(stat: stat)
            stackView.addArrangedSubview(row)
        }
    }
}
