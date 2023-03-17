import UIKit

class HomeViewController: BaseViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let leftMenuButton = UIButton()
    let topLabel = UILabel()
    let profileImageView = UIImageView()
    let locationButton = UIButton()
    let searchTextField = UITextField()
    lazy var viewModel = {
       HomeViewModel()
    }()
    
    private enum UIConstants {
        static let topLabelFont = 24.0
        static let leftMenuImageConfigur = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .large)
        static let topLabelAnchor = 5.0
        static let leftMenuButtonAnchor = 10.0
        static let magnifierImageConfigutation = UIImage.SymbolConfiguration(scale: .default)
        static let magnifierImage = UIImage(systemName: Resources.Images.magnifier,withConfiguration: UIConstants.magnifierImageConfigutation)
        static let searchTextFeidlTopAnchor = 10.0
        static let leftSearchTextFieldAnchor = 57.0
        static let searchPlaceholderFont = 14.0
        static let categorySectionLeadingInset = 5.0
        static let latestCellHeight = 149.0
        static let flashSaleCellHeight = 221.0
        static let latestSectionLeadingInset = 20.0
        static let profileImageWidth = 32.0
        static let profileImageRightAnchor = 47.0
        static let profileImageeLeftAnchor = 56.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.asyncGroupLoadDataFromServer()
        self.viewModel.errorCompletion = { [weak self] errorText in
            guard let self = self else {return}
            self.present(self.createInfoAlert(message: errorText, title: Resources.Titles.error),animated: true)
        }
        self.viewModel.stateCompletion = { [weak self] state in
            switch state {
            case .successFetch:
                self?.reloadCollectionView()
            default:
                break
            }
        }
    }
}


//MARK: - Configure VC
extension HomeViewController {
    override func addViews() {
        self.view.addView(topLabel)
        self.view.addView(profileImageView)
        self.view.addView(locationButton)
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
        
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.image = UIImage(named: Resources.Images.profileCustom)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = UIConstants.profileImageWidth / 2
        
        locationButton.setTitle(Resources.Titles.location, for: .normal)
        locationButton.setTitleColor(.gray, for: .normal)
        locationButton.setImage(UIImage(systemName: Resources.Images.chevronDown,withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
        locationButton.tintColor = .black
        locationButton.semanticContentAttribute = .forceRightToLeft
        locationButton.titleLabel?.font = .systemFont(ofSize: 13.0)
        
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = self.createCompositionLayout()
        collectionView.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.goodsCollectViewCell)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.categoryCollectViewCell)
        collectionView.register(FlashSaleCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.flashSaleCollectViewCell)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Resources.identefiers.collectionHeader)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topLabelAnchor),
            leftMenuButton.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            leftMenuButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.leftMenuButtonAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            profileImageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.profileImageRightAnchor),
            profileImageView.leftAnchor.constraint(lessThanOrEqualTo: topLabel.rightAnchor, constant: UIConstants.profileImageeLeftAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: UIConstants.profileImageWidth),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            locationButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            locationButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            searchTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: UIConstants.searchTextFeidlTopAnchor),
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
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section,_) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.firstLayoutSection()
            case 1: return self.secondLayoutSection()
            case 2: return self.thirdLayoutSection()
            default: return nil
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.166),heightDimension: .absolute(100))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 8, leading: 0, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .estimated(500))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = UIConstants.categorySectionLeadingInset

      return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),heightDimension: .absolute(UIConstants.latestCellHeight))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalWidth(0.5))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = UIConstants.latestSectionLeadingInset
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]

      return section
    }
    
    private func thirdLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),heightDimension: .absolute(UIConstants.flashSaleCellHeight))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .estimated(500))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = UIConstants.latestSectionLeadingInset
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]

      return section
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)),elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
    }
}


//MARK: - Collection methods
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.categoryCollectViewCell, for: indexPath) as? CategoryCollectionViewCell {
                if let data = self.viewModel.getContentData(indexPath: indexPath) {
                    cell.configureCell(image: UIImage(named: data.image), titleText: data.name)
                }
                return cell
            } else {return UICollectionViewCell()}
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.goodsCollectViewCell, for: indexPath) as? GoodsCollectionViewCell {
                cell.setShimmer()
                switch self.viewModel.state {
                case .successFetch:
                    if let data = self.viewModel.getContentData(indexPath: indexPath) {
                        self.viewModel.loadImage(data.image) { image in
                            cell.configureCell(image: image, category: data.category, name: data.name, price: data.price)
                        }
                    }
                default:
                    break
                }
                return cell
            } else {return UICollectionViewCell()}
        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.flashSaleCollectViewCell, for: indexPath) as? FlashSaleCollectionViewCell {
                cell.setShimmer()
                switch self.viewModel.state {
                case .successFetch:
                    if let data = self.viewModel.getContentData(indexPath: indexPath) {
                        self.viewModel.loadImage(data.image) { image in
                            cell.buildCell(image: image, category: data.category, name: data.name, price: data.price, discount: data.discount)
                        }
                    }
                default:
                    break
                }
                return cell
            } else {return UICollectionViewCell()}
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Resources.identefiers.collectionHeader, for: indexPath) as! HeaderSupplementaryView
            if let title = self.viewModel.getSectionTitle(indexPath: indexPath) {
                header.configureHeader(headerText: title)
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
