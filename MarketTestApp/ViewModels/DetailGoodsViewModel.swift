import Combine
import Foundation
import UIKit

enum MathOperation {
    case minus, plus
}

enum DetailGoodsViewState {
    case none,failedFetch(String),successFetchContent,successFetchImages
}

final class DetailGoodsViewModel:NSObject {
    
    private let networkManager:NetworkManager = .init()
    var stateCompletion: ((DetailGoodsViewState) -> Void)?
    private var state:DetailGoodsViewState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
    public var goodsData:DetailGoods?
    public var previousSelectedCellIndexPath:IndexPath = .init(row: 0, section: 1) // store previous selected cell in 1 section for shrinking when another one was tapped
    public var isSelectedImage:Bool = false  // flag parameter to check in willDisplayCell method when not swiping
    private var images:[UIImage] = [] // store loaded images of goods
    @Published private var price = 0
    @Published private var goodsCount = 0

    var pricePublished:AnyPublisher<String,Never> {
        Publishers.CombineLatest($price, $goodsCount)
            .map{ price, count in
                return "#\(count), $\(price)"
            }.eraseToAnyPublisher()
    }
    
    private enum Constants {
        static let sectionCount = 4
        static let thirdSectionItemsNumber = 1
    }
    
    public func viewDidLoad() {
        guard let url = URL(string: Resources.Links.detailGoods) else {return}
        self.loadGoodsData(url) { resultGoodsData in
            self.goodsData = resultGoodsData
            self.state = .successFetchContent
            self.loadImages(resultGoodsData.imageUrls)
        }
    }
    
    private func loadGoodsData(_ url:URL,withCompletion completion:@escaping (DetailGoods) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkManager.load(url: url) { (detailGoods:DetailGoods?, error:Error?) in
                if let error = error {
                    self.state = .failedFetch(error.localizedDescription)
                    return
                }
                guard let detailGoods = detailGoods else {return}
                DispatchQueue.main.async {completion(detailGoods)}
            }
        }
    }
    
    private func loadImages(_ imagesURL:[String]) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        
        for imageURL in imagesURL {
            if let url = URL(string: imageURL) {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInitiated).async {
                    self.networkManager.load(url: url) { (image: UIImage?, error:Error?) in
                        if let error = error {
                            self.state = .failedFetch(error.localizedDescription)
                            return
                        }
                        guard let image = image else {return}
                        dispatchQueue.sync {
                            self.images.append(image)
                            dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.state = .successFetchImages
        }
    }
    
    public func getImage(_ indexPath:IndexPath) -> UIImage? {
        switch self.state {
        case .successFetchImages:
            return self.images[indexPath.row]
        default:
            return nil
        }
    }
    
    public func getHexStringColor(_ indexPath:IndexPath) -> String? {
        self.goodsData?.colors[indexPath.row]
    }
    
    public func numberOfSections() -> Int {
        Constants.sectionCount
    }
    
    public func numberOfItemsInSection(_ section:Int) -> Int {
        switch section {
        case 0,1:
            switch self.state {
            case .successFetchImages:
                return self.images.count
            default:
                return self.goodsData?.imageUrls.count ?? 0
            }
        case 2: return Constants.thirdSectionItemsNumber
        case 3: return self.goodsData?.colors.count ?? 0
        default: return 0
        }
    }
    
    public func changePrice(_ mathOperation: MathOperation) {
        guard let price = self.goodsData?.price else {return}
        switch mathOperation {
        case .plus:
            self.price += price
            self.goodsCount += 1
        case .minus:
            self.price -= price
            self.goodsCount -= 1
            guard self.price >= 0 else {
                self.price = 0
                self.goodsCount = 0
                return
            }
        }
    }
    
    public func didSelectItemAt(_ collectionView:UICollectionView, _ indexPath:IndexPath) {
        switch indexPath.section {
        case 1:
            guard self.previousSelectedCellIndexPath != indexPath else {return}
            let largeImageIndexPath = IndexPath(item: indexPath.row, section: 0)
            collectionView.selectItem(at: largeImageIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            guard let previousSelectedCell = collectionView.cellForItem(at: self.previousSelectedCellIndexPath) as? ImageCollectionViewCell else {return}
            previousSelectedCell.shrink()
            self.previousSelectedCellIndexPath = indexPath
            self.isSelectedImage = true
        default:
            break
        }
    }
    
    public func willDisplay(_ collectionView:UICollectionView, _ indexPath:IndexPath) {
        switch indexPath.section {
        case 0:
            guard self.isSelectedImage != true else {return}
            let smallImageIndexPath = IndexPath(item: indexPath.row, section: 1)
            collectionView.selectItem(at: smallImageIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            guard self.previousSelectedCellIndexPath != smallImageIndexPath else {return}
            guard let previousSelectedCell = collectionView.cellForItem(at: self.previousSelectedCellIndexPath) as? ImageCollectionViewCell else {return}
            previousSelectedCell.shrink()
            self.previousSelectedCellIndexPath = smallImageIndexPath
        default:
            break
        }
    }
    
    public func didEndDisplaying(_ indexPath:IndexPath) {
        switch indexPath.section {
        case 0:
            self.isSelectedImage = false
        default:
            break
        }
    }
    
}
