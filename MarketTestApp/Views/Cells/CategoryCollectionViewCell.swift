import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var gradient: CAGradientLayer = CAGradientLayer()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let backgroundCircleView = UIView()
    
    private enum UIConstants {
        static let titleFont = 9.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(image:UIImage?,titleText:String) {
        self.imageView.image = image
        self.titleLabel.text = titleText
    }
}

extension CategoryCollectionViewCell:CollectionCellProtocol {
    
    func setupView() {
        imageView.contentMode = .scaleAspectFit
        titleLabel.textColor = .lightGray
        titleLabel.font = .systemFont(ofSize: UIConstants.titleFont)
        titleLabel.textAlignment = .center
        self.addView(titleLabel)
        
        backgroundCircleView.backgroundColor = .systemGray6.withAlphaComponent(0.7)
        backgroundCircleView.clipsToBounds = true
        backgroundCircleView.layer.cornerRadius = self.frame.height / 4
        self.addView(backgroundCircleView)
        
        backgroundCircleView.addView(imageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundCircleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundCircleView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundCircleView.heightAnchor.constraint(equalToConstant: self.frame.height / 2),
            backgroundCircleView.widthAnchor.constraint(equalToConstant: self.frame.height / 2),
            titleLabel.topAnchor.constraint(equalTo: backgroundCircleView.bottomAnchor,constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor),
            titleLabel.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor),
            imageView.centerXAnchor.constraint(equalTo: backgroundCircleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundCircleView.centerYAnchor)
        ])
    }
}
