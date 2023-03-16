import UIKit

class FlashSaleCollectionViewCell: GoodsCollectionViewCell {
    
    let favoriteButton = UIButton()
    let discountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FlashSaleCollectionViewCell {
    override func setupView() {
        super.setupView()
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
}
