import UIKit

class GoodsCollectionViewCell: UICollectionViewCell {
    
    var gradient: CAGradientLayer = CAGradientLayer()
    let imageView = UIImageView()
    let categoryLabel = PaddingLabel(withInsets: 5,5,7,7)
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let addButton = UIButton()
    
    private enum Constants {
        static let priceInitText = "$ "
        static let priceFont = 10.0
        static let nameFont = 13.0
        static let categoryFont = 11.0
        static let cornerRadius = 10.0
        static let categoryCornerRadius = 9.0
        static let leftRightAnchor = 10.0
        static let topBottomAnchor = 2.0
        static let categoryLabelYAnchor = 20.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoodsCollectionViewCell:CollectionCellProtocol {
    
    func setupView() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.addView(imageView)
        
        priceLabel.text = Constants.priceInitText
        priceLabel.textColor = .white
        priceLabel.font = .boldSystemFont(ofSize: Constants.priceFont)
        imageView.addView(priceLabel)
        
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        nameLabel.font = .boldSystemFont(ofSize: Constants.nameFont)
        imageView.addView(nameLabel)
        
        categoryLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: Constants.categoryFont)
        categoryLabel.clipsToBounds = true
        categoryLabel.layer.masksToBounds = true
        categoryLabel.layer.cornerRadius = Constants.categoryCornerRadius
        categoryLabel.sizeToFit()
        imageView.addView(categoryLabel)
    
        addButton.setImage(UIImage(named: Resources.Images.plusFilled), for: .normal)
        imageView.addView(addButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor,constant: Constants.leftRightAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,constant: Constants.categoryLabelYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: Constants.leftRightAnchor),
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.topBottomAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor,constant: Constants.topBottomAnchor),
            nameLabel.rightAnchor.constraint(equalTo: self.centerXAnchor,constant: Constants.leftRightAnchor),
            priceLabel.topAnchor.constraint(lessThanOrEqualTo: nameLabel.bottomAnchor,constant: Constants.topBottomAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -Constants.topBottomAnchor),
            priceLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: Constants.leftRightAnchor),
            priceLabel.rightAnchor.constraint(equalTo: self.centerXAnchor,constant: Constants.leftRightAnchor),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -Constants.leftRightAnchor),
            addButton.rightAnchor.constraint(equalTo: imageView.rightAnchor,constant: -Constants.leftRightAnchor)
        ])
    }
}

@objc extension GoodsCollectionViewCell {
    func configureCell(image:UIImage,category:String,name:String,price:Double) {
        self.imageView.image = image
        self.categoryLabel.text = category
        self.nameLabel.text = name
        self.priceLabel.text! += String(price)
        self.removeShimmer()
    }
}

extension GoodsCollectionViewCell:SkeletonLoadable {
    func setShimmer() {
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradient)
        
        let animationGroup = self.makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: Resources.Keys.gradientBackground)
        gradient.frame = self.bounds
    }
}
