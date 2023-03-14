import UIKit

extension String {
    
    struct EmailValidation {
        private static let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        private static let serverPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        private static let emailRegex = firstPart + "@" + serverPart + "[A-Za-z]{2,8}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
    }
    
    func isValidEmail() -> Bool {
        EmailValidation.emailPredicate.evaluate(with: self)
    }
}
