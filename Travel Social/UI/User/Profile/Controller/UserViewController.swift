//
//  UserViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 26/01/2021.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [Post]()
    var dataUser = DataManager.shared.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataUser = DataManager.shared.user
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InfoUserTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoUserTableViewCell")
        tableView.register(UINib(nibName: "ListFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "ListFriendTableViewCell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    func setDataPost() {
        DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
            self.dataSources = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showsetting(sender: UIButton!) {
        let buttonTag: UIButton = sender
        if buttonTag.tag == 1 {
            self.present(setting(), animated: false, completion: nil)
        }
    }
    
    func setting() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.pruneNegativeWidthConstraints()
        return alertController
    }
    
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 470
        case 1:
            return 140
        default:
            return 425
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 45))
            let logoutButton = UIButton()
            logoutButton.frame = CGRect.init(x: Int(UIScreen.main.bounds.width)-45, y: 5, width: 35, height: 35)
            logoutButton.setImage(UIImage(named: "setting"), for: .normal)
            logoutButton.addTarget(self, action: #selector(showsetting(sender:)), for: .touchUpInside)
            logoutButton.tag = 1
            headerView.addSubview(logoutButton)
            return headerView
        }
        return nil
    }
    
}

extension UserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoUserTableViewCell", for: indexPath) as? InfoUserTableViewCell else { return InfoUserTableViewCell() }
            cell.cellDelegate = self
            cell.selectionStyle = .none
            cell.setData(item: dataUser)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFriendTableViewCell", for: indexPath) as? ListFriendTableViewCell else { return ListFriendTableViewCell() }
            cell.selectionStyle = .none
            cell.countFriendLabel.text = String(DataManager.shared.user.listIdFriends?.count ?? 0) + " friends"
            cell.cellDelegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return PostTableViewCell() }
            cell.dataPost = dataSources[indexPath.section - 2]
            cell.setdata(data: dataSources[indexPath.section - 2])
            return cell
        }
    }
    
}

extension UserViewController: InfoUserTableViewCellDelegate {
    func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UserViewController: ListFriendTableViewCellDelegate {
    func showListFriend(viewController: UIViewController) {
        DataManager.shared.getUserFromListId(listId: dataUser.listIdFriends ?? []) { result in
            let listFriendViewController = viewController as? ListFriendViewController
            if result.count != 0 {
                listFriendViewController?.dataSources = result
                self.navigationController?.pushViewController(listFriendViewController!, animated: true)
            }
        }
    }
}
