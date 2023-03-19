import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    var gradient: CAGradientLayer = CAGradientLayer()
    
    private enum UIConstants {
        static let cornerRadius = 10.0
        static let borderWidth = 2.0
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.darkGray.cgColor : UIColor.lightGray.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(_ color:UIColor?) {
        self.removeShimmer()
        self.backgroundColor = color
    }
}

extension ColorCollectionViewCell {
    private func setupView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = UIConstants.cornerRadius
        self.layer.borderWidth = UIConstants.borderWidth
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension ColorCollectionViewCell:SkeletonLoadable {
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
