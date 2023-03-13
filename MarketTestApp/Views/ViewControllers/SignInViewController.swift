import UIKit

class SignInViewController: BaseViewController {

    let signInLabel = UILabel()
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
    let confirmButton = UIButton()
    let loginTextLabel = UILabel()
    let loginButton = UIButton()
    let googleButton = UIButton()
    let appleButton = UIButton()
    var scrollView = UIScrollView()
    let contentVertStackView = UIStackView()
    let loginHorizontalStackView = UIStackView()
        
    lazy var viewModel = {
       SignInViewModel()
    }()
    
    private enum UIConstants {
        static let viewHeightBetweenTopAnchorAndLabel = 125.0
        static let viewHeightBetweenTopLabelAndTextField = 78.0
        static let viewHeightBetweenTextFields = 35.0
        static let viewHeightBetweenButtonAndLoginText = 16.0
        static let viewHeightBetweenLoginTextAndGoogleButton = 73.0
        static let viewHeightBetweenGoogleButtonAndAppleButton = 37.0
        static let edgeWidthTextField = 44.0
        static let buttonHeight = 46.0
        static let loginTextFont = 14.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - Configure VC
extension SignInViewController {
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addView(contentVertStackView)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = true
        
        scrollView.showsVerticalScrollIndicator = false
        
        contentVertStackView.alignment = .center
        contentVertStackView.axis = .vertical
        
        let topView = UIView()
        topView.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenTopAnchorAndLabel).isActive = true
        contentVertStackView.addArrangedSubview(topView)
        
        signInLabel.text = Resources.Titles.signIn
        signInLabel.font = .boldSystemFont(ofSize: Resources.Fonts.loginTopLabel)
        contentVertStackView.addArrangedSubview(signInLabel)
        
        let viewBtwLabelTF = UIView()
        viewBtwLabelTF.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenTopLabelAndTextField).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwLabelTF)
        
        firstNameTextField.configureSignInTextField(placeholder: Resources.Titles.firstName)
        firstNameTextField.returnKeyType = .next
        firstNameTextField.delegate = self
        contentVertStackView.addArrangedSubview(firstNameTextField)
        
        let viewBtwTextFields = UIView()
        viewBtwTextFields.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenTextFields).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwTextFields)
        
        lastNameTextField.configureSignInTextField(placeholder: Resources.Titles.lastName)
        lastNameTextField.returnKeyType = .next
        lastNameTextField.delegate = self
        contentVertStackView.addArrangedSubview(lastNameTextField)
        
        let secondViewBtwTextFields = UIView()
        secondViewBtwTextFields.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenTextFields).isActive = true
        contentVertStackView.addArrangedSubview(secondViewBtwTextFields)
        
        emailTextField.configureSignInTextField(placeholder: Resources.Titles.email)
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self
        contentVertStackView.addArrangedSubview(emailTextField)
        
        let viewBtwButtonTF = UIView()
        viewBtwButtonTF.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenTextFields).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwButtonTF)
        
        confirmButton.configureSignInButton(Resources.Titles.signIn)
        contentVertStackView.addArrangedSubview(confirmButton)
        
        loginTextLabel.text = Resources.Titles.loginTextInSignIn
        loginTextLabel.textColor = .lightGray
        loginTextLabel.font = .systemFont(ofSize: UIConstants.loginTextFont)
        
        loginButton.setTitle(Resources.Titles.login, for: .normal)
        loginButton.setTitleColor(.link, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: UIConstants.loginTextFont)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        loginHorizontalStackView.alignment = .center
        loginHorizontalStackView.spacing = 10
        loginHorizontalStackView.axis = .horizontal
        loginHorizontalStackView.distribution = .fill
        loginHorizontalStackView.addArrangedSubview(loginTextLabel)
        loginHorizontalStackView.addArrangedSubview(loginButton)
        loginHorizontalStackView.addArrangedSubview(UIView())
        
        let viewBtwButtonLogin = UIView()
        viewBtwButtonLogin.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenButtonAndLoginText).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwButtonLogin)
        
        contentVertStackView.addArrangedSubview(loginHorizontalStackView)
        
        let viewBtwButtonGoogle = UIView()
        viewBtwButtonGoogle.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenLoginTextAndGoogleButton).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwButtonGoogle)
                
        let googleButtonConfiguration = self.createExternalServiceButton(UIImage(named: Resources.Images.google), Resources.Titles.signInWithGoogle)
        googleButton.configuration = googleButtonConfiguration
        contentVertStackView.addArrangedSubview(googleButton)
        
        let viewBtwGoogleApple = UIView()
        viewBtwGoogleApple.heightAnchor.constraint(equalToConstant: UIConstants.viewHeightBetweenGoogleButtonAndAppleButton).isActive = true
        contentVertStackView.addArrangedSubview(viewBtwGoogleApple)
        
        let appleButtonConfiguration = self.createExternalServiceButton(UIImage(named: Resources.Images.apple), Resources.Titles.signInWithApple)
        appleButton.configuration = appleButtonConfiguration
        contentVertStackView.addArrangedSubview(appleButton)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: contentVertStackView.frame.height),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            contentVertStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentVertStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentVertStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentVertStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentVertStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            firstNameTextField.leftAnchor.constraint(equalTo: contentVertStackView.leftAnchor, constant: UIConstants.edgeWidthTextField),
            firstNameTextField.rightAnchor.constraint(equalTo: contentVertStackView.rightAnchor, constant: -UIConstants.edgeWidthTextField),
            lastNameTextField.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor),
            lastNameTextField.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
            emailTextField.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor),
            emailTextField.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
            confirmButton.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
            confirmButton.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            loginHorizontalStackView.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor),
        ])
    }
}

//MARK: - Private methods
extension SignInViewController {
    private func createExternalServiceButton(_ image:UIImage?,_ title:String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.image = image
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 10
        return configuration
    }
}

//MARK: - Buttons methods
extension SignInViewController {
    @objc private func loginButtonTapped(_ sender:UIButton) {
        super.appCoordinator.showLoginVC()
    }
}


//MARK: - TextFieldDelegate
extension SignInViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            
            emailTextField.becomeFirstResponder()
        case emailTextField:
            
            emailTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

