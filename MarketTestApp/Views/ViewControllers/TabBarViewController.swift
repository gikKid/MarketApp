import UIKit

class TabBarViewController: UITabBarController {

    let appCoordinator:AppCoordinator
    
    private enum UIConstants {
        static let tabBarCornerRadius = 30.0
        static let UIImageTabBarConfigur = UIImage.SymbolConfiguration(weight: .heavy)
        static let tabbarHeight = 100.0
        static let circleSelectedItemHeight = 50.0
    }
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame.size.height = UIConstants.tabbarHeight
        tabBar.frame.origin.y = view.frame.size.height - UIConstants.tabbarHeight
        self.configureSelectedItem()
    }
}

//MARK: - TabbarDelegate
extension TabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.animateSelection(item)
    }
}


//MARK: - Private Methods
extension TabBarViewController {
    
    private func configureSelectedItem() {
        let size = CGSize(width: tabBar.frame.width / CGFloat(tabBar.items!.count) , height: tabBar.frame.height)
        let dotImage = UIImage().createSelectionIndicator(color: UIColor(named: Resources.Colors.selectedTabBar)!.withAlphaComponent(0.1), size: size, lineHeight: UIConstants.circleSelectedItemHeight)
        tabBar.selectionIndicatorImage = dotImage
    }
    
    private func configureTabBar() {
        self.appCoordinator.navigationController.navigationBar.isHidden = true
        self.view.backgroundColor = .systemBackground

        let homeVC = appCoordinator.createHomeVC()
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.house,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 0)
        
        let favoriteVC = UIViewController()
        favoriteVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.heart,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 1)
        
        let cartVC = UIViewController()
        cartVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.cart,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 2)
        
        let commentVC = UIViewController()
        commentVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.commentLeft,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 3)
        
        let profileVC = UIViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.person,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 4)
        
        self.viewControllers = [homeVC,favoriteVC,cartVC,commentVC,profileVC]
        
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = UIConstants.tabBarCornerRadius
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = UIColor(named: Resources.Colors.selectedTabBar)!.withAlphaComponent(0.9)
    }
    
    private func animateSelection(_ item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else {return}
        let timeInterval:TimeInterval = 0.2
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({barItemView.transform = .identity},delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}
