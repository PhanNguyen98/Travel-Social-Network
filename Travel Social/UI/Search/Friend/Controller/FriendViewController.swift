//
//  FriendViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 27/01/2021.
//

import UIKit

class FriendViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataUser = User()
    var dataPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileFriendTableViewCell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    func setNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension FriendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 440
        default:
            return 425
        }
    }
    
}

extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataPost.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFriendTableViewCell", for: indexPath) as? ProfileFriendTableViewCell else {
                return ProfileFriendTableViewCell()
            }
            cell.selectionStyle = .none
            cell.dataUser = dataUser
            cell.setData(user: dataUser)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return PostTableViewCell()
            }
            cell.cellDelegate = self
            cell.selectionStyle = .none
            cell.setdata(data: dataPost[indexPath.section - 1])
            cell.dataPost = dataPost[indexPath.section - 1]
            return cell
        }
    }
    
}

extension FriendViewController: PostTableViewCellDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, nameImage: String) {
        let detailImageViewController = DetailImageViewController()
        detailImageViewController.nameImage = nameImage
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
        self.present(commentViewController, animated: true, completion: nil)
    }
    
}

extension FriendViewController: CommentViewControllerDelegate {
    
    func reloadCountComment() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
