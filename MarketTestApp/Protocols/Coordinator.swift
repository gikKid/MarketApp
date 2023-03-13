import UIKit


protocol Coordinator {
    var navigationController:UINavigationController {get set}
    func start()
    
    init(_ navigationController:UINavigationController)
}
