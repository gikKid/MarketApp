import UIKit

class LoginViewController: BaseViewController {

    let topLabel = UILabel()
    let firstNameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let scrollView = UIScrollView()
    let verticalContentStackView = UIStackView()
    let eyeButton = UIButton(type: .custom)
        
    private enum UIConstants {
        static let topHeightView = 126.0
        static let heightViewbetweenLabelAndTextField = 80.0
        static let heightViewBetweenTextFields = 35.0
        static let hieghtViewBetweenTextFieldAndButton = 99.0
        static let buttonHeight = 46.0
        static let edgeWidthTextField = 44.0
        static let eyeImageConfigutation = UIImage.SymbolConfiguration(scale: .default)
        static let eyeImage = UIImage(systemName: Resources.Images.eye,withConfiguration: UIConstants.eyeImageConfigutation)
        static let notEyeImage = UIImage(systemName: Resources.Images.notEye,withConfiguration: UIConstants.eyeImageConfigutation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - Configure VC
extension LoginViewController {
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addView(verticalContentStackView)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = true
        
        scrollView.showsVerticalScrollIndicator = false
        
        verticalContentStackView.alignment = .center
        verticalContentStackView.axis = .vertical
        
        let viewBtwTopLabel = UIView()
        viewBtwTopLabel.heightAnchor.constraint(equalToConstant: UIConstants.topHeightView).isActive = true
        verticalContentStackView.addArrangedSubview(viewBtwTopLabel)
        
        topLabel.text = Resources.Titles.welcomeBack
        topLabel.font = .boldSystemFont(ofSize: Resources.Fonts.loginTopLabel)
        verticalContentStackView.addArrangedSubview(topLabel)
        
        let viewBtwLabelTF = UIView()
        viewBtwLabelTF.heightAnchor.constraint(equalToConstant: UIConstants.heightViewbetweenLabelAndTextField).isActive = true
        verticalContentStackView.addArrangedSubview(viewBtwLabelTF)
        
        firstNameTextField.configureSignInTextField(placeholder: Resources.Titles.firstName)
        verticalContentStackView.addArrangedSubview(firstNameTextField)
        
        let viewBtfTextFields = UIView()
        viewBtfTextFields.heightAnchor.constraint(equalToConstant: UIConstants.heightViewBetweenTextFields).isActive = true
        verticalContentStackView.addArrangedSubview(viewBtfTextFields)
        
        passwordTextField.configureSignInTextField(placeholder: Resources.Titles.password)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightViewMode = .always
        
        var eyeButtonConfiguration = UIButton.Configuration.plain()
        eyeButtonConfiguration.image = UIConstants.notEyeImage
        eyeButtonConfiguration.imagePadding = 10
        eyeButtonConfiguration.baseForegroundColor = .gray
        
        eyeButton.configuration = eyeButtonConfiguration
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        
        passwordTextField.rightView = eyeButton
 
        verticalContentStackView.addArrangedSubview(passwordTextField)
        
        let viewBtwTFButton = UIView()
        viewBtwTFButton.heightAnchor.constraint(equalToConstant: UIConstants.hieghtViewBetweenTextFieldAndButton).isActive = true
        verticalContentStackView.addArrangedSubview(viewBtwTFButton)
        
        loginButton.configureSignInButton("Login")
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.disableButton(loginButton, .background)
        verticalContentStackView.addArrangedSubview(loginButton)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            scrollView.heightAnchor.constraint(equalToConstant: verticalContentStackView.frame.height),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            verticalContentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalContentStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            verticalContentStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            verticalContentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            verticalContentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            firstNameTextField.rightAnchor.constraint(equalTo: verticalContentStackView.rightAnchor, constant: -UIConstants.edgeWidthTextField),
            firstNameTextField.leftAnchor.constraint(equalTo: verticalContentStackView.leftAnchor, constant: UIConstants.edgeWidthTextField),
            passwordTextField.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
            loginButton.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
            loginButton.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight)
        ])
    }
}


//MARK: - Button method
extension LoginViewController {
    @objc private func loginButtonTapped(_ sender:UIButton) {
    }
    
    @objc private func eyeButtonTapped(_ sender:UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.setImage(passwordTextField.isSecureTextEntry == true ? UIConstants.notEyeImage : UIConstants.eyeImage, for: .normal)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
