import UIKit 

final class ModeSelectorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        let swiftUIButton = UIButton(type: .system)
        swiftUIButton.setTitle("SwiftUI MVVM", for: .normal)
        swiftUIButton.addTarget(self, action: #selector(openSwiftUI), for: .touchUpInside)
        
        let uiKitButton = UIButton(type: .system)
        uiKitButton.setTitle("UIKit VIPER", for: .normal)
        uiKitButton.addTarget(self, action: #selector(openUIKit), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [swiftUIButton, uiKitButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func openSwiftUI() {
        let view = PokemonListFactory.createModule()
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func openUIKit() {
        let home = HomeFactory.createModule()
        navigationController?.pushViewController(home, animated: true)
    }
    
    @objc func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")

        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen

        if let window = view.window {
            window.rootViewController = nav
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionFlipFromTop,
                              animations: nil)
        }
    }
}
