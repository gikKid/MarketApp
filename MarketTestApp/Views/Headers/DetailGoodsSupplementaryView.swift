import UIKit

class DetailGoodsSupplementaryView: UICollectionReusableView {
    
    let colorLabel = UILabel()
    
    private enum UIConstants {
        static let labelFont = 12.0
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

extension DetailGoodsSupplementaryView {
    private func setupView() {
        colorLabel.textColor = .darkGray
        colorLabel.font = .boldSystemFont(ofSize: UIConstants.labelFont)
        colorLabel.text = "\(Resources.Titles.color):"
        self.addView(colorLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            colorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
}
