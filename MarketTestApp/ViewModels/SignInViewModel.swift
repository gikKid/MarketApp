import Foundation
import Combine

enum Fields {
    case firstName(String)
    case secondName(String)
    case email(String)
}

enum SigninState {
    case successRegister,none
}

final class SignInViewModel:NSObject {
    
    var errorCompletion: ((String) -> Void)?
    var stateCompletion: ((SigninState) -> Void)?
    
    var state:SigninState = .none {
        didSet {
            stateCompletion?(state)
        }
    }
    
    @Published private var firstName = ""
    @Published private var secondName = ""
    @Published private var email = ""
    
    var isValidEmailPublisher:AnyPublisher<Bool,Never> {
        $email.map{$0.isValidEmail()}
            .eraseToAnyPublisher()
    }
    
    var isSigninEnabled:AnyPublisher<Bool,Never> {
        Publishers.CombineLatest3($firstName, $secondName, isValidEmailPublisher)
            .map{ name, surname, isValidEmail in
                return !name.isEmpty && !surname.isEmpty && isValidEmail
            }.eraseToAnyPublisher()
    }
    
    public func setField(field:Fields) {
        switch field {
        case .email(let email):
            self.email = email
        case .firstName(let firstName):
            self.firstName = firstName
        case .secondName(let secondName):
            self.secondName = secondName
        }
    }
    
    
    public func userTapSigninButton() {
        if self.isUniqueEmail() {
            do {
                try DataStorageManager.shared.createUser(email: self.email,firstName: self.firstName, secondName: self.secondName)
                self.state = .successRegister
                self.saveEntered()
            } catch let error {
                self.errorCompletion?("\(error.localizedDescription)")
            }
        } else {
            self.errorCompletion?(Resources.Titles.emailUniqueError)
        }
    }
    
    private func isUniqueEmail()  -> Bool {
        var isUnique = false
        do {
            let users = try DataStorageManager.shared.loadLocalUsers()
            if !users.isEmpty {
                users.forEach{ user in
                    if user.email == self.email {
                        isUnique = false
                        return
                    }
                }
            } else {
                isUnique = true
            }
        } catch let error {
            self.errorCompletion?("\(error)")
        }
        return isUnique
    }
}

extension SignInViewModel:LoginViewModelProtocol {}
