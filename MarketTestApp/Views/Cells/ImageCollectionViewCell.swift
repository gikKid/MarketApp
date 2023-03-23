import UIKit

enum ImageCellType {
    case def,scalable
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    var gradient: CAGradientLayer = CAGradientLayer()
    private let imageView = UIImageView()
    private var type:ImageCellType = .def
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseOut, animations: {
                self.transform = (self.type == .scalable) ? CGAffineTransform(scaleX: 1.1, y: 1.3) : CGAffineTransform(scaleX: 1, y: 1)
            })
            if type == .scalable && isSelected == true {
                self.addShadow()
            }
        }
    }
    
    private enum UIConstants {
        static let cornerRadius = 10.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(_ image:UIImage?,_ type:ImageCellType = .def) {
        self.imageView.image = image
        self.type = type
        self.removeShimmer()
    }
    
    public func shrink() {
        UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        self.removeShadow()
    }
}


extension ImageCollectionViewCell {
    private func setupView() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = UIConstants.cornerRadius
        self.layer.cornerRadius = UIConstants.cornerRadius
        self.layer.masksToBounds = false

        imageView.contentMode = .scaleAspectFill
        self.contentView.addView(imageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    
    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.15
        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    private func removeShadow() {
        self.layer.shadowOpacity = 0
    }
}

extension ImageCollectionViewCell: SkeletonLoadable {
    func setShimmer() {
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.contentView.layer.addSublayer(gradient)
        
        let animationGroup = self.makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: Resources.Keys.gradientBackground)
        gradient.frame = self.bounds
    }
}
