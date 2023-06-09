import UIKit

final class AppCoordinator:Coordinator {
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let defaults = UserDefaults.standard
        let isEntered = defaults.bool(forKey: Resources.Keys.isEntered)
        switch isEntered {
        case true:
            self.showTabBarVC()
        case false:
            self.showSigninVC()
        }
    }
    
    func showDetailGoodsVC() {
        let detailGoodsVC = DetailGoodsViewController(appCoordinator: self)
        detailGoodsVC.hidesBottomBarWhenPushed = false
        navigationController.pushViewController(detailGoodsVC, animated: true)
    }
    
    func showSigninVC() {
        let signinVC = SignInViewController(appCoordinator: self)
        navigationController.setViewControllers([signinVC], animated: true) // first view when user for the first time open app
    }
    
    func showLoginVC() {
        let loginVC = LoginViewController(appCoordinator: self)
        navigationController.setViewControllers([loginVC], animated: true) // in tech task we havent back navigation button
    }
    
    func showTabBarVC() {
        let tabBarVC = TabBarViewController(appCoordinator: self)
        navigationController.setViewControllers([tabBarVC], animated: true)
    }
    
    func createHomeVC() -> HomeViewController{
        HomeViewController(appCoordinator: self)
    }
    
    func createProfileVC() -> ProfileViewController {
        ProfileViewController(appCoordinator: self)
    }
}
