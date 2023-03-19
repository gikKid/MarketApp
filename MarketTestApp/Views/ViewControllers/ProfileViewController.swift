import UIKit

class ProfileViewController: BaseViewController {

    private let topLabel = UILabel()
    private let tableView = UITableView()
    private let tableHeaderView = TableHeaderView()
    let avatarPhotoPicker = UIImagePickerController()
    lazy var viewModel = {
       ProfileViewModel()
    }()
    
    private enum UIConstants {
        static let topLabelFont = 18.0
        static let topLabelTopAnchor = 20.0
        static let cellHeight = 65.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.stateCompletion = { [weak self] state in
            switch state {
            case .logout:
                self?.appCoordinator.showSigninVC()
            default:
                break
            }
        }
    }
}


//MARK: - Configure VC

extension ProfileViewController {
    override func addViews() {
        self.view.addView(topLabel)
        self.view.addView(tableView)
    }
    
    override func configure() {
        super.configure()
        
        topLabel.text = Resources.Titles.profile
        topLabel.font = .boldSystemFont(ofSize: UIConstants.topLabelFont)
        
        tableHeaderView.delegate = self
        tableHeaderView.model = .init(name: "Satria Adhi Pradana", image: UIImage(named: Resources.Images.profileCustom))
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: Resources.identefiers.profileTableCell)
        
        avatarPhotoPicker.allowsEditing = true
        avatarPhotoPicker.delegate = self
    }
    
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topLabelTopAnchor),
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Private methods
extension ProfileViewController {
    private func showPickerAlert() {
        let pickerAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        pickerAlert.addAction(UIAlertAction(title: Resources.Titles.takePhoto, style: .default,handler: { _ in
            self.avatarPhotoPicker.sourceType = .camera // in device simulator it will be crashed !!!
            self.present(self.avatarPhotoPicker, animated: true)
        }))
        pickerAlert.addAction(UIAlertAction(title: Resources.Titles.chooseFromPhotoGallery, style: .default,handler: { _ in
            self.present(self.avatarPhotoPicker, animated: true)
        }))
        pickerAlert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
        self.present(pickerAlert, animated: true)
    }
}


//MARK: - TableViewDelegate
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Resources.identefiers.profileTableCell, for: indexPath) as? ProfileTableViewCell {
            let cellData = self.viewModel.getCellData(indexPath)
            cell.configure(model: cellData)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRowAt(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.view.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.cellHeight
    }
    
}


//MARK: - TableHeaderViewDelegate
extension ProfileViewController: TableHeaderViewProtocol {
    func userTapChangePhotoButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Change avatar", style: .default,handler: { [weak self] _ in
            guard let self = self else {return}
            self.showPickerAlert()
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancel, style: .cancel))
        self.present(alert, animated: true)
    }
}


//MARK: - ImagePickerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        tableHeaderView.changeImage(image)
        avatarPhotoPicker.dismiss(animated: true)
    }
}
