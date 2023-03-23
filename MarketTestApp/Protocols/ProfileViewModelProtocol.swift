import Foundation

protocol ProfileViewModelProtocol {
    func saveLogout()
}

extension ProfileViewModelProtocol {
    func saveLogout() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: Resources.Keys.isEntered)
    }
}
