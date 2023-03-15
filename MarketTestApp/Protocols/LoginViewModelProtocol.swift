import Foundation

protocol LoginViewModelProtocol {
    func saveEntered()
}

extension LoginViewModelProtocol {
    func saveEntered() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Resources.UserDefault.isEnteredKey)
    }
}
