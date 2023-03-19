import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var gradient: CAGradientLayer = CAGradientLayer()
    private let imageView = UIImageView()
    
    private enum UIConstants {
        static let imageCornerRadius = 10.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(_ image:UIImage?) {
        self.imageView.image = image
        self.removeShimmer()
    }
}


extension ImageCollectionViewCell {
    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.imageCornerRadius
        self.addView(imageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension ImageCollectionViewCell: SkeletonLoadable {
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
