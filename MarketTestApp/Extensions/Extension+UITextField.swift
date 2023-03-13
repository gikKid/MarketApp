import UIKit

extension UITextField {
    func configureSignInTextField(placeholder:String) {
        let centeredParagrapghStyle = NSMutableParagraphStyle()
        centeredParagrapghStyle.alignment = .center
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor:UIColor.placeholderText,.paragraphStyle: centeredParagrapghStyle])
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Resources.CornerRadius.textFieldSignIn
        self.font = .systemFont(ofSize: Resources.Fonts.textFieldSignIn)
        self.borderStyle = .roundedRect
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
        self.backgroundColor = .systemGray5
        self.contentVerticalAlignment = .center
    }
}
