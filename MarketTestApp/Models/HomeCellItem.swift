struct HomeCellItem {
    let category:String
    let price:Double
    let name:String
    let image:String
    var discount:Int = 0
}

enum HomeCellSection {
    case category([HomeCellItem])
    case latest([HomeCellItem])
    case flashSale([HomeCellItem])
    
    var items:[HomeCellItem] {
        switch self {
        case .latest(let items),.flashSale(let items),.category(let items):
            return items
        }
    }
    
    var count:Int {
        items.count
    }
    
    var title:String {
        switch self {
        case .latest(_):
            return Resources.Titles.latestSection
        case .flashSale(_):
            return Resources.Titles.flashSaleSection
        case .category(_):
            return ""
        }
    }
}
