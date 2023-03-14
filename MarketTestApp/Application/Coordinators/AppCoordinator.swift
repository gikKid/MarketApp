import UIKit

final class AppCoordinator:Coordinator {
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let signinVC = SignInViewController(appCoordinator: self)
        navigationController.setViewControllers([signinVC], animated: true) // first view when user for the first time open app
    }
    
    func showLoginVC() {
        let loginVC = LoginViewController(appCoordinator: self)
        navigationController.setViewControllers([loginVC], animated: true) // in tech task we havent back navigation button
    }
    
    func showMainVC() {
        let mainVC = MainViewController(appCoordinator: self)
        navigationController.setViewControllers([mainVC], animated: true)
    }
}
