import UIKit

class ProfileTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let iconImageView = UIImageView()
    let rightButton = UIButton()
    let iconContainerView = UIView()
    
    private enum UIConstants {
        static let titleFont = 18.0
        static let labelXOffset = 25.0
        static let iconLeftAnchor = 35.0
        static let rightImageAnchor = 40.0
        static let rightButtonFont = 17.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model:ProfileCellOption) {
        self.iconImageView.image = model.image
        self.titleLabel.text = model.title
        if let image = model.image {
            iconContainerView.layer.cornerRadius = image.size.width / 2
        }
        
        switch model.type {
        case .empty:
            self.rightButton.removeFromSuperview()
        case .balance:
            guard let balance = model.balance else {return}
            rightButton.setTitle("$ \(balance)", for: .normal)
            break
        case .rightChevron:
            rightButton.setImage(UIImage(systemName: Resources.Images.chevronRight,withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
            break
        }
        self.layoutIfNeeded()
    }
}

extension ProfileTableViewCell {
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        iconContainerView.clipsToBounds = true
        
        iconContainerView.layer.masksToBounds = true
        contentView.addView(iconContainerView)
        
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: UIConstants.titleFont)
        contentView.addView(titleLabel)
        
        rightButton.tintColor = .black
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: UIConstants.rightButtonFont)
        contentView.addView(rightButton)
        
        iconImageView.tintColor = .black
        iconImageView.contentMode = .scaleAspectFit
        
        iconContainerView.addView(iconImageView)
        iconContainerView.backgroundColor = .systemGray6.withAlphaComponent(0.8)
    }
    
    private func setConstaints() {
        NSLayoutConstraint.activate([
            iconContainerView.widthAnchor.constraint(equalToConstant: contentView.frame.size.height - 7),
            iconContainerView.heightAnchor.constraint(equalTo: iconContainerView.widthAnchor),
            iconContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: UIConstants.iconLeftAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: (contentView.frame.size.height - 7) / 1.5),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - UIConstants.labelXOffset - iconContainerView.frame.size.width),
            titleLabel.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconContainerView.rightAnchor,constant: 10),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -UIConstants.rightImageAnchor)
        ])
    }
}
