import Foundation
import UIKit

enum HomeViewState {
    case successFetch,none
}

final class HomeViewModel:NSObject {
    public var errorCompletion: ((String) -> Void)?
    private let networkManager = NetworkManager()
    private var contentData:[HomeCellSection] = [.category([
        .init(category: "", price: 0, name: Resources.Titles.phones, image: Resources.Images.phones),
        .init(category: "", price: 0, name: Resources.Titles.headphones, image:Resources.Images.headphones),
        .init(category: "", price: 0, name: Resources.Titles.games, image: Resources.Images.games),
        .init(category: "", price: 0, name: Resources.Titles.cars, image: Resources.Images.cars),
        .init(category: "", price: 0, name: Resources.Titles.furniture, image: Resources.Images.furniture),
        .init(category: "", price: 0, name: Resources.Titles.kids, image: Resources.Images.kids)]),
                                                 .latest([]),
                                                 .flashSale([])
    ]
    public var stateCompletion: ((HomeViewState) -> Void)?
    public var state:HomeViewState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
    
    
    private enum Constants {
        static let defaultCellsCount = 4
        static let sectionCount = 2
    }
    
    public func getContentData(indexPath:IndexPath) -> HomeCellItem {
        self.contentData[indexPath.section].items[indexPath.row]
    }
    
    public func getSectionTitle(indexPath:IndexPath) -> String {
        self.contentData[indexPath.section].title
    }
    
    public func loadImage(_ urlString:String,withCompletion completion:@escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkManager.load(url: url) { (image:UIImage?, error:Error?) in
                if let error = error {
                    self.errorCompletion?("\(error.localizedDescription)")
                    return
                }
                guard let image = image else {return}
                DispatchQueue.main.async {completion(image)}
            }
        }
    }
    
    public func numberOfSections() -> Int {
        Constants.sectionCount
//        self.contentData.count
    }
    
    public func numberOfItemsInSection(section:Int) -> Int{
        switch section {
        case 0: return self.contentData[section].count
        case 1:
            switch self.state {
            case .successFetch:
                return self.contentData[section].count
            default:
                return Constants.defaultCellsCount
            }
        case 2:
            switch self.state {
            case .successFetch:
                return self.contentData[section].count
            default:
                return Constants.defaultCellsCount
            }
        default:
            return 0
        }
    }
    
    private func getLatestData(completion: @escaping ([Latest]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkManager.load(url: URL(string: Resources.Links.latest)!) { (result: LatestWrapper? ,error:Error?)   in
                if let error = error {
                    self.errorCompletion?("\(error.localizedDescription)")
                    return
                }
                guard let result = result else {return}
                DispatchQueue.main.async {completion(result.latest)}
            }
        }
    }

    private func getFlashSaleData(completion: @escaping ([FlashSale]) -> Void) {
         DispatchQueue.global(qos: .userInitiated).async {
             self.networkManager.load(url: URL(string: Resources.Links.flashSale)!) { (result: FlashSaleWrapper?,error:Error? )  in
                 if let error = error {
                     self.errorCompletion?("\(error.localizedDescription)")
                     return
                 }
                guard let result = result else {return}
                DispatchQueue.main.async {completion(result.flashSale)}
            }
        }
    }
    
//    private func test<T>(url:URL,type:T,completion: @escaping (T) -> Void) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.networkManager.load(url: url) { (result: T?,error:Error? )  in
//                if let error = error {
//                    self.errorCompletion?("\(error.localizedDescription)")
//                    return
//                }
//
//               guard let result = result else {return}
//               DispatchQueue.main.async {completion(result)}
//           }
//       }
//    }
    
    public func asyncGroupLoadDataFromServer() {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        
//        dispatchGroup.enter()
//        test(url: URL(string: Resources.Links.latest)!, type: LatestWrapper.self) { result in
//
//        }
   
        dispatchGroup.enter()
        getLatestData { data in
            let latestCellItems = data.map{HomeCellItem(category: $0.category, price: Double($0.price), name: $0.name, image: $0.imageURL)}
            let latestSection = HomeCellSection.latest(latestCellItems)
            dispatchQueue.sync {
                self.contentData.insert(latestSection, at: 1)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        getFlashSaleData { data in
            let flashSaleCellItems = data.map{HomeCellItem(category: $0.category, price: $0.price, name: $0.name, image: $0.imageURL)}
            let flashSaleSection = HomeCellSection.flashSale(flashSaleCellItems)
            dispatchQueue.sync {
                self.contentData.insert(flashSaleSection, at: 2)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.state = .successFetch
        }
    }
}
