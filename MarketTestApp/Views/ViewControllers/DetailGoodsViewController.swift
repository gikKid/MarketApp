import UIKit
import Combine

class DetailGoodsViewController: BaseViewController {

    let backButton = UIButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let addToCartView = UIView()
    let quantityLabel = UILabel()
    let minusButton = UIButton()
    let plusButton = UIButton()
    let bottomCartView = UIView()
    let totalPriceLabel = UILabel()
    let addToCartLabel = UILabel()
    private var priceSubscriber:AnyCancellable?
    lazy var viewModel = {
       DetailGoodsViewModel()
    }()
    
    private enum UIConstants {
        static let bottomCartViewHeight = 85.0
        static let bottomCartViewCornerRadius = 25.0
        static let backButtonImageConfigure = UIImage.SymbolConfiguration(pointSize: 0, weight: .bold, scale: .large)
        static let mathButtonImageConfigure = UIImage.SymbolConfiguration(scale: .small)
        static let quantityLabelFont = 13.0
        static let minusButtonWidth = 39.0
        static let minusButtonHeight = 22.0
        static let minusButtonCornerRadius = 7.0
        static let addToCartViewRightAnchor = 25.0
        static let addToCartViewLeftAnchor = 60.0
        static let addToCartViewCornerRadius = 15.0
        static let addToCartFont = 12.0
        static let backButtonLeftTopAnchor = 15.0
        static let quantityLabelTopLeftAnchor = 15.0
        static let minusButtonTopAnchor = 15.0
        static let plusButtonLeftAnchor = 20.0
        static let addToCartLabelRightAnchor = 25.0
        static let totalPriceLeftAnchor = 30.0
        static let secondSectionLeftRightInset = 76.0
        static let totalPriceLabelRightAnchor = 10.0
        static let collectionTopLeftRightAnchor = 10.0
        static let secondSectionImageHeight = 50.0
        static let thirdSectionHeight = 100.0
        static let fourthSectionHeight = 30.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
        self.viewModel.stateCompletion = { state in
            switch state {
            case .successFetchContent:
                self.reloadContentSections()
            case .successFetchImages:
                self.reloadImagesSection()
            case .failedFetch(let errorText):
                self.present(self.createInfoAlert(message: errorText, title: Resources.Titles.error), animated: true)
            default:
                break
            }
        }
        priceSubscriber = self.viewModel.pricePublished
            .receive(on: RunLoop.main)
            .sink(receiveValue: { price in
                self.totalPriceLabel.text = "$ \(price)"
            })
    }
}


//MARK: - Configure VC
extension DetailGoodsViewController {
    override func addViews() {
        self.view.addView(backButton)
        self.view.addView(collectionView)
        self.view.addView(bottomCartView)
        bottomCartView.addView(quantityLabel)
        bottomCartView.addView(minusButton)
        bottomCartView.addView(plusButton)
        bottomCartView.addView(addToCartView)
        addToCartView.addView(addToCartLabel)
        addToCartView.addView(totalPriceLabel)
    }
    
    override func configure() {
        super.configure()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = self.createCompositionLayout()
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.imageCell)
        collectionView.register(DetailGoodsCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.detailGoodsCell)
        collectionView.register(DetailGoodsSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Resources.identefiers.detailGoodsCollectHeaderView)
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: Resources.identefiers.colorDetailGoodsCell)
        
        backButton.setImage(UIImage(systemName: Resources.Images.chevronLeft,withConfiguration: UIConstants.backButtonImageConfigure), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        bottomCartView.backgroundColor = UIColor(named: Resources.Colors.bottomCartBackColor)
        bottomCartView.layer.masksToBounds = true
        bottomCartView.layer.cornerRadius = UIConstants.bottomCartViewCornerRadius
        bottomCartView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        quantityLabel.text = "\(Resources.Titles.quantity):"
        quantityLabel.textColor = .gray
        quantityLabel.font = .systemFont(ofSize: UIConstants.quantityLabelFont)
        
        self.configureMathButton(minusButton, UIImage(systemName: Resources.Images.minus,withConfiguration: UIConstants.mathButtonImageConfigure))
        minusButton.addTarget(self, action: #selector(mathButtonTapped), for: .touchUpInside)
        self.configureMathButton(plusButton, UIImage(systemName: Resources.Images.plus,withConfiguration: UIConstants.mathButtonImageConfigure))
        plusButton.addTarget(self, action: #selector(mathButtonTapped), for: .touchUpInside)
        
        addToCartView.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        addToCartView.clipsToBounds = true
        addToCartView.layer.cornerRadius = UIConstants.addToCartViewCornerRadius
        
        addToCartLabel.text = Resources.Titles.addToCard
        addToCartLabel.font = .boldSystemFont(ofSize: UIConstants.addToCartFont)
        addToCartLabel.textColor = .white
        
        totalPriceLabel.textColor = .lightGray
        totalPriceLabel.font = .systemFont(ofSize: UIConstants.addToCartFont)
        totalPriceLabel.text = "$0"
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.backButtonLeftTopAnchor),
            backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.backButtonLeftTopAnchor),
            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor,constant: UIConstants.collectionTopLeftRightAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -UIConstants.collectionTopLeftRightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: UIConstants.collectionTopLeftRightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomCartView.topAnchor),
            bottomCartView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomCartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            bottomCartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            bottomCartView.heightAnchor.constraint(equalToConstant: UIConstants.bottomCartViewHeight),
            quantityLabel.topAnchor.constraint(equalTo: bottomCartView.topAnchor, constant: UIConstants.quantityLabelTopLeftAnchor),
            quantityLabel.leftAnchor.constraint(equalTo: bottomCartView.leftAnchor, constant: UIConstants.quantityLabelTopLeftAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: UIConstants.minusButtonWidth),
            minusButton.heightAnchor.constraint(equalToConstant: UIConstants.minusButtonHeight),
            minusButton.leftAnchor.constraint(equalTo: quantityLabel.leftAnchor),
            minusButton.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: UIConstants.minusButtonTopAnchor),
            plusButton.topAnchor.constraint(equalTo: minusButton.topAnchor),
            plusButton.leftAnchor.constraint(equalTo: minusButton.rightAnchor, constant: UIConstants.plusButtonLeftAnchor),
            plusButton.widthAnchor.constraint(equalTo: minusButton.widthAnchor),
            plusButton.heightAnchor.constraint(equalTo: minusButton.heightAnchor),
            addToCartView.centerYAnchor.constraint(equalTo: bottomCartView.centerYAnchor),
            addToCartView.rightAnchor.constraint(equalTo: bottomCartView.rightAnchor, constant: -UIConstants.addToCartViewRightAnchor),
            addToCartView.leftAnchor.constraint(equalTo: plusButton.rightAnchor, constant: UIConstants.addToCartViewLeftAnchor),
            addToCartView.heightAnchor.constraint(equalToConstant: UIConstants.bottomCartViewHeight / 2),
            addToCartLabel.centerYAnchor.constraint(equalTo: addToCartView.centerYAnchor),
            addToCartLabel.rightAnchor.constraint(equalTo: addToCartView.rightAnchor, constant: -UIConstants.addToCartLabelRightAnchor),
            totalPriceLabel.centerYAnchor.constraint(equalTo: addToCartView.centerYAnchor),
            totalPriceLabel.leftAnchor.constraint(equalTo: addToCartView.leftAnchor, constant: UIConstants.totalPriceLeftAnchor),
            totalPriceLabel.rightAnchor.constraint(lessThanOrEqualTo: addToCartLabel.leftAnchor, constant: -UIConstants.totalPriceLabelRightAnchor)
        ])
    }
}

//MARK: - Private methods
extension DetailGoodsViewController {
    private func configureMathButton(_ button: UIButton,_ image:UIImage?) {
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        button.layer.cornerRadius = UIConstants.minusButtonCornerRadius
        button.clipsToBounds = true
    }
    
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section,_) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.firstLayoutSection()
            case 1: return self.secondLayoutSection()
            case 2: return self.thirdLayoutSection()
            case 3: return self.fourthLayoutSection()
            default: return nil
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let height = self.view.frame.height / 3
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(height))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 0)
        return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),heightDimension: .absolute(UIConstants.secondSectionImageHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(UIConstants.secondSectionImageHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: UIConstants.secondSectionLeftRightInset, bottom: 0, trailing: UIConstants.secondSectionLeftRightInset)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20, leading: 0, bottom: 10, trailing:  0)
        return section
    }
    
    private func thirdLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(UIConstants.thirdSectionHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(UIConstants.thirdSectionHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    private func fourthLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.15),heightDimension: .absolute(UIConstants.fourthSectionHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .estimated(UIConstants.fourthSectionHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 0)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)),elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
    }
    
    private func reloadImagesSection() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    
    private func reloadContentSections() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 2))
            self.collectionView.reloadSections(IndexSet(integer: 3))
        }
    }
}


//MARK: - Buttons methods
extension DetailGoodsViewController {
    @objc private func backButtonTapped(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func mathButtonTapped(_ sender: UIButton) {
        switch sender {
        case minusButton:
            self.viewModel.changePrice(.minus)
        default:
            self.viewModel.changePrice(.plus)
        }
    }
}


//MARK: - CollectionViewMethods
extension DetailGoodsViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.imageCell, for: indexPath) as? ImageCollectionViewCell {
                cell.setShimmer()
                if let image = self.viewModel.getImage(indexPath) {
                    cell.configureCell(image)
                }
                return cell
            } else {return UICollectionViewCell()}
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.imageCell, for: indexPath) as? ImageCollectionViewCell {
                cell.setShimmer()
                if let image = self.viewModel.getImage(indexPath) {
                    cell.configureCell(image)
                }
                return cell
            } else {return UICollectionViewCell()}
        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.detailGoodsCell, for: indexPath) as? DetailGoodsCollectionViewCell {
                cell.setShimmer()
                if let goodsData = self.viewModel.goodsData {
                    cell.configureCell(goodsData)
                }
                return cell
            } else {return UICollectionViewCell()}
        case 3:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.identefiers.colorDetailGoodsCell, for: indexPath) as? ColorCollectionViewCell {
                cell.setShimmer()
                let hexString = self.viewModel.getHexStringColor(indexPath)
                let color = UIColor(hexString: hexString)
                cell.configureCell(color)
                return cell
            } else {return UICollectionViewCell()}
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 3:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Resources.identefiers.detailGoodsCollectHeaderView, for: indexPath) as! DetailGoodsSupplementaryView
                return header
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
}
