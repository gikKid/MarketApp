import UIKit

enum ColorButtonType {
    case background
    case tint
    case title
}

class BaseViewController: UIViewController {
    
    let childSpinner = SpinnerViewController()
    let appCoordinator:AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.addViews()
        self.configure()
        self.layoutViews()
    }
}

@objc extension BaseViewController {
    public func addViews() {}
    public func configure() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.view.backgroundColor = .systemBackground
    }
    public func layoutViews() {}
    
    public func createInfoAlert(message:String, title:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Resources.Titles.confirmAlertActionTitle, style: .default, handler: nil))
        return alert
    }
}

extension BaseViewController {
    
    public func createSpinnerView() {
        addChild(childSpinner)
        childSpinner.view.frame = view.frame
        view.addSubview(childSpinner.view)
        childSpinner.didMove(toParent: self)
    }
    
    public func hideSpinnerView() {
        childSpinner.willMove(toParent: nil)
        childSpinner.view.removeFromSuperview()
        childSpinner.removeFromParent()
    }
    
    public func disableButton(_ button:UIButton,_ colorType:ColorButtonType) {
        button.isEnabled = false
        
        switch colorType {
        case .background:
            button.backgroundColor = .lightGray
        case .title:
            button.setTitleColor(.gray, for: .normal)
        case .tint:
            button.tintColor = .gray
        }
    }
    
    public func enableButton(_ button:UIButton,_ color:UIColor,_ colorType:ColorButtonType) {
        button.isEnabled = true
        
        switch colorType {
        case .background:
            button.backgroundColor = color
        case .title:
            button.setTitleColor(color, for: .normal)
        case .tint:
            button.tintColor = color
        }
    }
}
