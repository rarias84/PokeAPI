import UIKit

extension UIColor {
    static func pokemonColor(_ name: String) -> UIColor {
        switch name.lowercased() {
        case "red": self.init(red: 0.9, green: 0.2, blue: 0.2, alpha: 1)
        case "blue": self.init(red: 0.2, green: 0.4, blue: 0.9, alpha: 1)
        case "green": self.init(red: 0.2, green: 0.7, blue: 0.3, alpha: 1)
        case "yellow": self.init(red: 0.95, green: 0.8, blue: 0.2, alpha: 1)
        case "purple": self.init(red: 0.6, green: 0.3, blue: 0.8, alpha: 1)
        case "brown": self.init(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        case "pink": .systemPink
        case "black": .black
        case "white": .white
        case "gray": .gray
        default: .systemGray
        }
    }
}
