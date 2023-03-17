import UIKit

class TabBarViewController: UITabBarController {

    let appCoordinator:AppCoordinator
    
    private enum UIConstants {
        static let tabBarCornerRadius = 30.0
        static let UIImageTabBarConfigur = UIImage.SymbolConfiguration(weight: .bold)
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
        super.viewDidLayoutSubviews()
        self.configureSelectedItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureCenteredItems()
    }
}


//MARK: - Private Methods
extension TabBarViewController {
    
    private func configureCenteredItems() {
        let buttons = tabBar.subviews.filter{String(describing: type(of: $0)) == "UITabBarButton"}
        buttons.forEach {
            if let superviewHeight = $0.superview?.frame.height {
                $0.center = CGPoint(x: $0.frame.midX, y: superviewHeight * 0.5)
            }
        }
    }
    
    private func configureSelectedItem() {
        let size = CGSize(width: tabBar.frame.width / CGFloat(tabBar.items!.count) , height: tabBar.frame.height)
        let dotImage = UIImage().createSelectionIndicator(color: UIColor(named: Resources.Colors.selectedTabBar)!.withAlphaComponent(0.1), size: size, lineHeight: tabBar.frame.height < 50 ? tabBar.frame.height / 1.4 : UIConstants.circleSelectedItemHeight) // 49 is tab bar height for iphone se 3 generation
        tabBar.selectionIndicatorImage = dotImage
    }
    
    private func configureTabBar() {
        self.appCoordinator.navigationController.navigationBar.isHidden = true
        self.view.backgroundColor = .systemBackground

        self.delegate = self
        
        let homeVC = appCoordinator.createHomeVC()
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.house,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 0)
        
        let favoriteVC = UIViewController()
        favoriteVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.heart,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 1)
        
        let cartVC = UIViewController()
        cartVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.cart,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 2)
        
        let commentVC = UIViewController()
        commentVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.commentLeft,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 3)
        
        let profileVC = appCoordinator.createProfileVC()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Resources.Images.person,withConfiguration: UIConstants.UIImageTabBarConfigur), tag: 4)
        
        self.viewControllers = [homeVC,favoriteVC,cartVC,commentVC,profileVC]
        
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.itemPositioning = .centered
        tabBar.layer.cornerRadius = UIConstants.tabBarCornerRadius
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = UIColor(named: Resources.Colors.selectedTabBar)!.withAlphaComponent(0.9)
    }
}

//MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {}
