//
//  HomeViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.tabBarController?.delegate = self
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "CreatePostTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatePostTableViewCell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    func setData() {
        var data = DataManager.shared.user.listIdFriends ?? []
        data.append(DataManager.shared.user.id!)
        DataManager.shared.getPostFromListId(listId: data) { result in
            if self.dataSources.count != result.count {
                self.dataSources = result
                self.tableView.reloadData()
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let createPostViewController = CreatePostViewController()
            self.navigationController?.pushViewController(createPostViewController, animated: true)
        default:
            let commentViewController = CommentViewController()
            commentViewController.dataPost = dataSources[dataSources.count - indexPath.section]
            commentViewController.commentDelegate = self
            self.navigationController?.pushViewController(commentViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 0
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return TitleTableViewCell()
            }
            cell.cellDelegate = self
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTableViewCell", for: indexPath) as? CreatePostTableViewCell else {
                return CreatePostTableViewCell()
            }
            cell.selectionStyle = .none
            cell.setData(item: DataManager.shared.user)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
                return PostTableViewCell()
            }
            cell.cellDelegate = self
            cell.dataPost = dataSources[dataSources.count - indexPath.section + 1]
            cell.setdata(data: dataSources[dataSources.count - indexPath.section + 1])
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

extension HomeViewController: PostTableViewCellDelegate {
    
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

extension HomeViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            var data = DataManager.shared.user.listIdFriends ?? []
            data.append(DataManager.shared.user.id!)
            DataManager.shared.getPostFromListId(listId: data) { result in
                if self.dataSources.count != result.count {
                    self.dataSources = result
                    self.tableView.reloadData()
                }
            }
        }
        
        if tabBarController.selectedIndex == 2 {
            let userViewController = viewController as? UserViewController
            DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
                userViewController?.dataPost = result
                DataManager.shared.setDataUser()
                userViewController?.dataUser = DataManager.shared.user
                userViewController?.tableView.reloadData()
            }
        }
    }
    
}

extension HomeViewController: CommentViewControllerDelegate {
    func reloadCountComment() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: TitleTableViewCellDelegate {
    func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentViewController(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
