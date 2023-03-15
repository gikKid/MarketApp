import UIKit

class HomeViewController: BaseViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let leftMenuButton = UIButton()
    let topLabel = UILabel()
    let searchTextField = UITextField()
    
    private enum UIConstants {
        static let topLabelFont = 24.0
        static let leftMenuImageConfigur = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .large)
        static let topLabelAnchor = 5.0
        static let leftMenuButtonAnchor = 10.0
        static let magnifierImageConfigutation = UIImage.SymbolConfiguration(scale: .default)
        static let magnifierImage = UIImage(systemName: Resources.Images.magnifier,withConfiguration: UIConstants.magnifierImageConfigutation)
        static let searchTextFeidlTopAnchor = 34.0
        static let leftSearchTextFieldAnchor = 57.0
        static let searchPlaceholderFont = 14.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - Configure VC
extension HomeViewController {
    override func addViews() {
        self.view.addView(topLabel)
        self.view.addView(leftMenuButton)
        self.view.addView(searchTextField)
        self.view.addView(collectionView)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        leftMenuButton.setImage(UIImage(systemName: Resources.Images.burgerMenu,withConfiguration:UIConstants.leftMenuImageConfigur ), for: .normal)
        leftMenuButton.tintColor = .black
        
        let mutableString = NSMutableAttributedString(string: Resources.Titles.mainTopText,attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIConstants.topLabelFont)
        ])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: Resources.Colors.mainColor)!, range: NSRange(location: 8, length: 5))
        topLabel.attributedText = mutableString
        
        let centeredParagrapghStyle = NSMutableParagraphStyle()
        centeredParagrapghStyle.alignment = .center
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: Resources.Placaholders.mainTopSearchBar,attributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray,.paragraphStyle: centeredParagrapghStyle])
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = Resources.CornerRadius.textFieldSignIn
        searchTextField.font = .systemFont(ofSize: UIConstants.searchPlaceholderFont)
        searchTextField.borderStyle = .roundedRect
        searchTextField.autocorrectionType = .no
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.backgroundColor = .systemGray6.withAlphaComponent(0.35)
        searchTextField.contentVerticalAlignment = .center
        searchTextField.rightViewMode = .always
        searchTextField.returnKeyType = .done
        
        let magnifierButton = UIButton()
        
        var magnifierButtonConfiguration = UIButton.Configuration.plain()
        magnifierButtonConfiguration.image = UIConstants.magnifierImage
        magnifierButtonConfiguration.imagePadding = 10
        magnifierButtonConfiguration.baseForegroundColor = .gray
        
        magnifierButton.configuration = magnifierButtonConfiguration
        
        searchTextField.rightView = magnifierButton
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topLabelAnchor),
            leftMenuButton.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            leftMenuButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.leftMenuButtonAnchor),
            searchTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: UIConstants.searchTextFeidlTopAnchor),
            searchTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.leftSearchTextFieldAnchor),
            searchTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.leftSearchTextFieldAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor,constant: 10),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


//MARK: - Private methods
extension HomeViewController {

}
