import UIKit

class FlashSaleCollectionViewCell: GoodsCollectionViewCell {
    
    private let favoriteButton = UIButton()
    private let discountLabel = PaddingLabel(withInsets: 3, 3, 7, 7)
    
    private enum UIConstants {
        static let discountFount = 15.0
        static let discountCornerRadius = 13.0
        static let nameFont = 16.0
        static let priceFont = 13.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildCell(image: UIImage, category: String, name: String, price: Double,discount:Int) {
        configureCell(image: image, category: category, name: name, price: price)
        self.discountLabel.text = "\(discount)% off"
    }
}

extension FlashSaleCollectionViewCell {
    override func setupView() {
        super.setupView()
        
        super.nameLabel.font = .boldSystemFont(ofSize: UIConstants.nameFont)
        super.priceLabel.font = .boldSystemFont(ofSize: UIConstants.priceFont)
        super.addButton.setImage(UIImage(named: Resources.Images.plusFilledX2), for: .normal)
        
        discountLabel.backgroundColor = .systemRed.withAlphaComponent(0.9)
        discountLabel.textColor = .white
        discountLabel.textAlignment = .center
        discountLabel.font = UIFont.boldSystemFont(ofSize: UIConstants.discountFount)
        discountLabel.clipsToBounds = true
        discountLabel.layer.masksToBounds = true
        discountLabel.layer.cornerRadius = UIConstants.discountCornerRadius
        discountLabel.sizeToFit()
        self.addView(discountLabel)
        
        favoriteButton.setImage(UIImage(named: Resources.Images.customHeart), for: .normal)
        self.addView(favoriteButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            discountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            favoriteButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -5)
        ])
    }
}
