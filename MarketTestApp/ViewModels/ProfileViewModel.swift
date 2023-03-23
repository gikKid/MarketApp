import UIKit

enum ProfileViewState {
    case logout,none
}

final class ProfileViewModel:NSObject, ProfileViewModelProtocol {

    public var stateCompletion: ((ProfileViewState) -> Void)?
    private var state:ProfileViewState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
    
    private let cellData:[ProfileCellOption] = [
        ProfileCellOption(title: Resources.Titles.tradeStore, image: UIImage(named: Resources.Images.creditcard), type: ProfileCellType.rightChevron),
        ProfileCellOption(title: Resources.Titles.paymentMethod, image: UIImage(named: Resources.Images.creditcard),type: ProfileCellType.rightChevron),
        ProfileCellOption(title: Resources.Titles.balance, image: UIImage(named: Resources.Images.creditcard),balance: 1593, type: ProfileCellType.balance), // hardcode balance argument
        ProfileCellOption(title: Resources.Titles.tradeHistory, image: UIImage(named: Resources.Images.creditcard),type: ProfileCellType.rightChevron),
        ProfileCellOption(title: Resources.Titles.restorePurchase, image: UIImage(named: Resources.Images.restore),type: ProfileCellType.rightChevron),
        ProfileCellOption(title: Resources.Titles.help, image: UIImage(named: Resources.Images.questionCircle),type: ProfileCellType.empty),
        ProfileCellOption(title: Resources.Titles.logout, image: UIImage(named: Resources.Images.logout),type: ProfileCellType.empty)
    ]
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfRowsInSection() -> Int {
        self.cellData.count
    }
    
    public func getCellData(_ indexPath:IndexPath) -> ProfileCellOption {
        self.cellData[indexPath.row]
    }
    
    public func didSelectRowAt(tableView:UITableView, indexPath:IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell {
            switch cell.titleLabel.text {
            case Resources.Titles.logout:
                self.state = .logout
                self.saveLogout()
            default:
                break
            }
        }
    }
}
