import Foundation
import Combine

enum LoginFields {
    case firstName(String)
    case password(String)
}

enum LoginState {
    case successLogin
    case failLogin(String)
    case none
}

final class LoginViewModel:NSObject,LoginViewModelProtocol {
    
    var errorCompletion: ((String) -> Void)?
    var stateCompletion:((LoginState) -> Void)?
    var state:LoginState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
     
    @Published private var firstName = ""
    @Published private var password = ""
    
    var isLoginEnabledPublisher:AnyPublisher<Bool,Never> {
        Publishers.CombineLatest($firstName, $password)
            .map { firstName, password in
                return !firstName.isEmpty && !password.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private func isExistingUser(_ firstName:String) -> Bool {
        var exist = false
        do {
            let storagedUsers = try DataStorageManager.shared.loadLocalUsers()
            storagedUsers.forEach{exist = $0.firstName == self.firstName ? true : false}
        } catch let error {
            self.errorCompletion?("\(error)")
        }
        return exist
    }
    
    public func userTapLogin() {
        self.state = isExistingUser(self.firstName) ? .successLogin : .failLogin(Resources.Titles.loginError)
    }
    
    public func setField(_ field:LoginFields) {
        switch field {
        case .firstName(let value):
            self.firstName = value
        case .password(let value):
            self.password = value
        }
    }
}
