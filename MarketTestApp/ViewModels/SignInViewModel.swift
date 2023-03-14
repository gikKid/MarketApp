import Foundation
import Combine

enum Fields {
    case firstName(String)
    case secondName(String)
    case email(String)
}

final class SignInViewModel:NSObject {
    @Published private var firstName = ""
    @Published private var secondName = ""
    @Published private var email = ""
    
    var isValidEmailPublisher:AnyPublisher<Bool,Never> {
        $email.map{$0.isValidEmail()}
            .eraseToAnyPublisher()
    }
    
    var isSignInenabled:AnyPublisher<Bool,Never> {
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
}
