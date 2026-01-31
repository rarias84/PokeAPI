import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let biometricButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Login"
        setupViews()
    }

    private func setupViews() {
        usernameField.placeholder = "Usuario"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no

        passwordField.placeholder = "Contraseña"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        loginButton.setTitle("Iniciar sesión", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        biometricButton.setTitle("Login biométrico", for: .normal)
        biometricButton.addTarget(self, action: #selector(didTapBiometric), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton, biometricButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func didTapLogin() {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert("Ingrese usuario y contraseña")
            return
        }

        if username == "test" && password == "1234" {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            navigateToModeSelector()
        } else {
            showAlert("Usuario o contraseña incorrectos")
        }
    }

    @objc private func didTapBiometric() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Autentícate") { success, _ in
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        self.navigateToModeSelector()
                    } else {
                        self.showAlert("Biometría fallida")
                    }
                }
            }
        } else {
            showAlert("Biometría no disponible")
        }
    }

    private func navigateToModeSelector() {
        let vc = ModeSelectorViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
