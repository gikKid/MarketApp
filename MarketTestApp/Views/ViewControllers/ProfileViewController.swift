import UIKit

class ProfileViewController: BaseViewController {

    private let topLabel = UILabel()
    private let tableView = UITableView()
    private let tableHeaderView = TableHeaderView()
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
        self.navigationController?.navigationBar.isHidden = true
        
        topLabel.text = Resources.Titles.profile
        topLabel.font = .boldSystemFont(ofSize: UIConstants.topLabelFont)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: Resources.identefiers.profileTableCell)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TableHeaderView()
        headerView.model = .init(name: "Satria Adhi Pradana", image: UIImage(named: Resources.Images.profileCustom))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.view.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.cellHeight
    }
    
}
