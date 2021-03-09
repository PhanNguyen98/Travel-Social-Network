//
//  UserViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 26/01/2021.
//

import UIKit

class UserViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dataPost = [Post]()
    var dataFriend = [User]()
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
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let commentViewController = CommentViewController()
            commentViewController.dataPost = dataPost[indexPath.row]
            commentViewController.commentDelegate = self
            self.navigationController?.pushViewController(commentViewController, animated: true)
        case 2:
            let friendViewController = FriendViewController()
            friendViewController.dataUser = dataFriend[indexPath.row]
            navigationController?.pushViewController(friendViewController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 45))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "  Profile"
            label.font = .boldSystemFont(ofSize: 23)
            label.textColor = .black
            headerView.addSubview(label)
            
            let logoutButton = UIButton()
            logoutButton.frame = CGRect.init(x: Int(UIScreen.main.bounds.width)-45, y: 5, width: 30, height: 30)
            logoutButton.setImage(UIImage(named: "options"), for: .normal)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return dataPost.count
        default:
            return dataFriend.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoUserTableViewCell", for: indexPath) as? InfoUserTableViewCell else { return InfoUserTableViewCell() }
            cell.cellDelegate = self
            cell.selectionStyle = .none
            cell.setData(item: dataUser, countPost: dataPost.count)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return PostTableViewCell() }
            cell.dataPost = dataPost[dataPost.count - indexPath.row - 1]
            cell.setdata(data: dataPost[dataPost.count - indexPath.row - 1])
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UserTableViewCell() }
            cell.selectionStyle = .none
            cell.setData(item: dataFriend[indexPath.row])
            return cell
        }
    }
    
}

extension UserViewController: InfoUserTableViewCellDelegate {
    func sendDataPost(dataPost: [Post]) {
        self.dataPost = dataPost
        self.dataFriend = [User]()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func sendDataFriend(dataFriend: [User]) {
        self.dataFriend = dataFriend
        self.dataPost = [Post]()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
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


extension UserViewController: PostTableViewCellDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, listImage: [String]) {
        let detailImageViewController = DetailImageViewController()
        detailImageViewController.dataSources = listImage
        self.navigationController?.pushViewController(detailImageViewController, animated: true)
    }
    
    func showListUser(listUser: [String]) {
        let listUserViewController = ListUserViewController()
        DataManager.shared.getListUser(listId: listUser) { result in
            listUserViewController.dataSources = result
            self.present(listUserViewController, animated: true, completion: nil)
        }
    }
    
    func showListComment(dataPost: Post) {
        let commentViewController = CommentViewController()
        commentViewController.dataPost = dataPost
        commentViewController.commentDelegate = self
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
    
}

extension UserViewController: CommentViewControllerDelegate {
    func reloadCountComment() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
