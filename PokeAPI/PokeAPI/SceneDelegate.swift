import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let rootVC: UIViewController
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            rootVC = ModeSelectorViewController()
        } else {
            rootVC = LoginViewController()
        }

        let nav = UINavigationController(rootViewController: rootVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}
