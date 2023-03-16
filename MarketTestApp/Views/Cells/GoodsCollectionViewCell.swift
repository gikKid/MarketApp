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
        static let nameFont = 14.0
        static let categoryFont = 11.0
        static let imageCornerRadius = 10.0
        static let categoryCornerRadius = 9.0
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
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
            categoryLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor,constant: 10),
            categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor,constant: -10),
            nameLabel.rightAnchor.constraint(equalTo: self.centerXAnchor,constant: 10),
            priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -10),
            priceLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 10),
            priceLabel.rightAnchor.constraint(equalTo: self.centerXAnchor,constant: 10),
            addButton.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            addButton.rightAnchor.constraint(equalTo: imageView.rightAnchor,constant: -10)
        ])
    }
    
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
        gradient.add(animationGroup, forKey: "backgroundColor")
        gradient.frame = self.bounds
    }
    
    func removeShimmer() {
        self.gradient.removeFromSuperlayer()
    }
}
