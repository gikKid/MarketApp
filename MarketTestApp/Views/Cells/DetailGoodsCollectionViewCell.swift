import UIKit

class DetailGoodsCollectionViewCell: UICollectionViewCell {
    
    var gradient: CAGradientLayer = CAGradientLayer()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let ratingLabel = UILabel()
    let reviewsLabel = UILabel()
    
    private enum UIConstants {
        static let nameLabelFont = 20.0
        static let priceLabelFont = 15.0
        static let infoFont = 12.0
        static let leftRightAnchor = 10.0
        static let topAnchor = 10.0
        static let btwInfoAnchor = 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(_ goodsData:DetailGoods) {
        self.removeShimmer()
        self.nameLabel.text = goodsData.name
        self.priceLabel.text = "$ \(goodsData.price)"
        self.descriptionLabel.text = goodsData.description
        self.ratingLabel.text = "\(goodsData.rating)"
        self.reviewsLabel.text = "(\(goodsData.numberOfReviews) reviews)"
    }
}

extension DetailGoodsCollectionViewCell {
    private func setupView() {
        nameLabel.font = .boldSystemFont(ofSize: UIConstants.nameLabelFont)
        nameLabel.numberOfLines = 0
        self.addView(nameLabel)
        priceLabel.font = .boldSystemFont(ofSize: UIConstants.priceLabelFont)
        self.addView(priceLabel)
        descriptionLabel.font = .systemFont(ofSize: UIConstants.infoFont)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        self.addView(descriptionLabel)
        starImageView.image = UIImage(systemName: Resources.Images.star,withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        starImageView.tintColor = .systemYellow
        self.addView(starImageView)
        ratingLabel.font = .systemFont(ofSize: UIConstants.infoFont)
        self.addView(ratingLabel)
        reviewsLabel.font = .systemFont(ofSize: UIConstants.infoFont)
        reviewsLabel.textColor = .gray
        self.addView(reviewsLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: UIConstants.leftRightAnchor),
            nameLabel.rightAnchor.constraint(equalTo: self.centerXAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -UIConstants.leftRightAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIConstants.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: UIConstants.leftRightAnchor),
            starImageView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            starImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: UIConstants.topAnchor),
            ratingLabel.leftAnchor.constraint(equalTo: starImageView.rightAnchor, constant: UIConstants.btwInfoAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            reviewsLabel.leftAnchor.constraint(equalTo: ratingLabel.rightAnchor, constant: UIConstants.btwInfoAnchor),
            reviewsLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
        ])
    }
}

extension DetailGoodsCollectionViewCell:SkeletonLoadable {
    func setShimmer() {
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.nameLabel.layer.addSublayer(gradient)
        self.priceLabel.layer.addSublayer(gradient)
        self.descriptionLabel.layer.addSublayer(gradient)
        self.ratingLabel.layer.addSublayer(gradient)
        self.reviewsLabel.layer.addSublayer(gradient)
        
        let animationGroup = self.makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: Resources.Keys.gradientBackground)
        gradient.frame = self.bounds
    }
}
