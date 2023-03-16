import UIKit

class HeaderSupplementaryView:UICollectionReusableView {
    private let haederLeftLabel = UILabel()
    private let viewAllButton = UIButton()
    
    private enum UIConstants {
        static let headerFont = 21.0
        static let rightAnchorButton = 10.0
        static let buttonFont = 13.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureHeader(headerText:String) {
        haederLeftLabel.text = headerText
    }
}


extension HeaderSupplementaryView {
    private func setupView() {
        haederLeftLabel.font = .boldSystemFont(ofSize: UIConstants.headerFont)
        haederLeftLabel.textAlignment = .center
        self.addView(haederLeftLabel)
        
        viewAllButton.setTitleColor(.lightGray, for: .normal)
        viewAllButton.titleLabel?.font = .systemFont(ofSize: UIConstants.buttonFont)
        viewAllButton.setTitle(Resources.Titles.viewAll, for: .normal)
        self.addView(viewAllButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            haederLeftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            haederLeftLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            viewAllButton.topAnchor.constraint(equalTo: self.topAnchor),
            viewAllButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -UIConstants.rightAnchorButton)
        ])
    }
}
