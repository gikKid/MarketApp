import UIKit

extension UIButton {
    func configureSignInButton(_ title:String) {
        self.setTitle(title, for: .normal)
        self.layer.masksToBounds = true
        self.isEnabled = false
        self.layer.cornerRadius = Resources.CornerRadius.buttonCornerSignIn
        self.backgroundColor = UIColor(named: Resources.Colors.mainColor)
        self.setTitleColor(.white, for: .normal)
    }
}
