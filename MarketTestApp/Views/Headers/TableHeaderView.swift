import UIKit

class TableHeaderView: UIView {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let changePhotoLabel = UILabel()
    private let uploadItemButton = UIButton()
    
    private enum UIConstants {
        static let imageWidth = 63.0
        static let changePhotoFont = 12.0
        static let nameFont = 18.0
        static let uploadItemHeight = 40.0
        static let uploadItemButtonLeftAnchor = 40.0
    }

    struct Model {
        let name:String
        let image:UIImage?
    }
    
    public var model:Model? = nil {
        didSet {
            nameLabel.text = model?.name
            imageView.image = model?.image
        }
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


extension TableHeaderView {
    private func setupView() {
        self.backgroundColor = .systemBackground
        
        imageView.layer.masksToBounds = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius =  UIConstants.imageWidth / 2
        self.addView(imageView)
        
        nameLabel.font = .boldSystemFont(ofSize: UIConstants.nameFont)
        nameLabel.textColor = .darkGray
        self.addView(nameLabel)
        
        changePhotoLabel.textColor = .gray
        changePhotoLabel.text = Resources.Titles.changePhoto
        changePhotoLabel.font = .systemFont(ofSize: UIConstants.changePhotoFont)
        self.addView(changePhotoLabel)
        
        uploadItemButton.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        uploadItemButton.setTitle(Resources.Titles.uploadItem, for: .normal)
        uploadItemButton.setImage( UIImage(systemName: Resources.Images.share,withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .bold, scale: .medium)), for: .normal)
        uploadItemButton.layer.masksToBounds = true
        uploadItemButton.isEnabled = false
        uploadItemButton.layer.cornerRadius = Resources.CornerRadius.buttonCornerSignIn
        uploadItemButton.setTitleColor(.white, for: .normal)
        uploadItemButton.imageView?.tintColor = UIColor.white
        uploadItemButton.tintColor = .white
        if let image = uploadItemButton.imageView?.image {
            uploadItemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width * 4)
        }
        self.addView(uploadItemButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: UIConstants.imageWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            changePhotoLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            changePhotoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: changePhotoLabel.bottomAnchor,constant: 20),
            uploadItemButton.heightAnchor.constraint(equalToConstant: UIConstants.uploadItemHeight),
            uploadItemButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            uploadItemButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -UIConstants.uploadItemButtonLeftAnchor),
            uploadItemButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIConstants.uploadItemButtonLeftAnchor)
        ])
    }
}
