import Foundation
import UIKit

enum HomeViewState {
    case successFetch,reloadSearchTableView,none
}

final class HomeViewModel:NSObject {
    public var errorCompletion: ((String) -> Void)?
    private let networkManager = NetworkManager()
    private var contentData:[String:HomeCellSection] = [Constants.categoryKey : .category([
        .init(category: "", price: 0, name: Resources.Titles.phones, image: Resources.Images.phones),
        .init(category: "", price: 0, name: Resources.Titles.headphones, image:Resources.Images.headphones),
        .init(category: "", price: 0, name: Resources.Titles.games, image: Resources.Images.games),
        .init(category: "", price: 0, name: Resources.Titles.cars, image: Resources.Images.cars),
        .init(category: "", price: 0, name: Resources.Titles.furniture, image: Resources.Images.furniture),
        .init(category: "", price: 0, name: Resources.Titles.kids, image: Resources.Images.kids)])
    ]
    private var APIWords:[String]?
    private var resultSearch:[String] = []
    private var searchString:String = ""
    public var stateCompletion: ((HomeViewState) -> Void)?
    public var state:HomeViewState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
    
    private enum Constants {
        static let defaultCellsCount = 4
        static let categoryKey = "Category"
        static let latestKey = "Latest"
        static let flashSaleKey = "flashSale"
        static let sectionCountSearchTableView = 1
    }
    
    public func fetchAPIWords() {
        guard self.APIWords == nil else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkManager.load(url: URL(string: Resources.Links.words)!) { (wordsWrapper: WordsWrapper?, error:Error?) in
                if let error = error {
                    self.errorCompletion?("\(error)")
                    return
                }
                guard let wordsWrapper = wordsWrapper else {return}
                self.APIWords = wordsWrapper.words
            }
        }
    }
    
    public func searchText(_ character:String) {
        if character == "" {
            searchString.removeLast()
        } else {
            searchString.append(character)
        }
        guard let apiWords = self.APIWords else {
            self.fetchAPIWords()
            return
        }
        self.resultSearch = apiWords.filter{$0.lowercased().contains(searchString.lowercased())}
        self.state = .reloadSearchTableView
    }
    
    public func getWord(_ indexPath: IndexPath) -> String {
        self.resultSearch[indexPath.row]
    }
    
    public func getContentData(indexPath:IndexPath) -> HomeCellItem? {
        switch indexPath.section {
        case 0: return self.contentData[Constants.categoryKey]?.items[indexPath.row]
        case 1: return self.contentData[Constants.latestKey]?.items[indexPath.row]
        case 2: return self.contentData[Constants.flashSaleKey]?.items[indexPath.row]
        default:
            return nil
        }
    }
    
    public func getSectionTitle(indexPath:IndexPath) -> String? {
        switch indexPath.section {
        case 0: return self.contentData[Constants.categoryKey]?.title
        case 1: return self.contentData[Constants.latestKey]?.title
        case 2: return self.contentData[Constants.flashSaleKey]?.title
        default:
            return nil
        }
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
    
    public func numberOfSectionsInSearchTableView() -> Int {
        Constants.sectionCountSearchTableView
    }
    
    public func numberOfRowsInSectionInSearchTableView() -> Int {
        self.resultSearch.count
    }
    
    public func numberOfSections() -> Int {
        self.contentData.count
    }
    
    public func numberOfItemsInSection(section:Int) -> Int? {
        switch section {
        case 0: return self.contentData[Constants.categoryKey]?.count
        case 1:
            switch self.state {
            case .successFetch:
                return self.contentData[Constants.latestKey]?.count
            default:
                return Constants.defaultCellsCount
            }
        case 2:
            switch self.state {
            case .successFetch:
                return self.contentData[Constants.flashSaleKey]?.count
            default:
                return Constants.defaultCellsCount
            }
        default:
            return nil
        }
    }
    
    private func loadData<T>(_ urlString:String, withCompletion completion: @escaping (T?,Error?) -> Void ) {
        guard let url = URL(string: urlString) else {return}
        DispatchQueue.global(qos: .userInitiated).async {self.networkManager.load(url: url, withCompletion: completion) }
    }
    
    public func asyncGroupLoadDataFromServer() {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
   
        dispatchGroup.enter()
        self.loadData(Resources.Links.latest) { (result: LatestWrapper?, error:Error?) in
            if let error = error {
                self.errorCompletion?("\(error.localizedDescription)")
                dispatchGroup.leave()
                return
            }
            guard let result = result else {return}
            let latestCellItems = result.latest.map{HomeCellItem(category: $0.category, price: Double($0.price), name: $0.name, image: $0.imageURL)}
            let latestSection = HomeCellSection.latest(latestCellItems)
            dispatchQueue.sync {
                self.contentData[Constants.latestKey] = latestSection
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        self.loadData(Resources.Links.flashSale) { (result:FlashSaleWrapper?,error:Error?) in
            if let error = error {
                self.errorCompletion?("\(error.localizedDescription)")
                dispatchGroup.leave()
                return
            }
            guard let result = result else {return}
            let flashSaleCellItems = result.flashSale.map{HomeCellItem(category: $0.category, price: $0.price, name: $0.name, image: $0.imageURL,discount: $0.discount)}
            let flashSaleSection = HomeCellSection.flashSale(flashSaleCellItems)
            dispatchQueue.sync {
                self.contentData[Constants.flashSaleKey] = flashSaleSection
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.state = .successFetch
        }
    }
}
