import UIKit

enum ProfileCellType {
    case balance, rightChevron, empty
}

struct ProfileCellOption {
    let title:String
    let image:UIImage?
    var balance:Int?
    let type: ProfileCellType
}
