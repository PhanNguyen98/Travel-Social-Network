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

//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setData()
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: SetData
    func setUpTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "CreatePostTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatePostTableViewCell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    func setData() {
        DataManager.shared.getUserFromId(id: DataManager.shared.user.id!) {
            var data = DataManager.shared.user.listIdFollowing ?? []
            data.append(DataManager.shared.user.id!)
            DataManager.shared.getPostFromListId(listId: data) { result in
                self.dataSources = result
                self.tableView.reloadData()
            }
        }
        handlePostChanges() { result in
            let indexPath = IndexPath(row: 0, section: self.dataSources.count - result)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
    
    func handlePostChanges(completed: @escaping (_ pos: Int) -> ()) {
        let db = Firestore.firestore()
        var data = DataManager.shared.user.listIdFollowers ?? []
        data.append(DataManager.shared.user.id!)
        db.collection("posts").whereField("idUser", in: data).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .modified) {
                    let docId = diff.document.documentID
                    if let indexOfPostToModify = self.dataSources.firstIndex(where: { $0.id == docId} ) {
                        let postToModify = self.dataSources[indexOfPostToModify]
                        postToModify.updatePost(withData: diff.document)
                        completed(indexOfPostToModify)
                    }
                }
            }
        }
    }
    
}

//MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:
            let commentViewController = CommentViewController()
            commentViewController.dataPost = dataSources[dataSources.count - indexPath.section]
            self.navigationController?.pushViewController(commentViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 435
        }
    }
}

//MARK: UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        headerView.backgroundColor = .systemGray6
        return headerView
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
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
                return PostTableViewCell()
            }
            cell.cellDelegate = self
            cell.dataPost = dataSources[dataSources.count - indexPath.section]
            cell.setdata(data: dataSources[dataSources.count - indexPath.section])
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

//MARK: PostTableViewCellDelegate
extension HomeViewController: PostTableViewCellDelegate {
    func showProfile(user: User) {
        DataManager.shared.getPostFromId(idUser: user.id!) { result in
            DataManager.shared.setDataUser()
            if user.id == DataManager.shared.user.id {
                let profileUserViewController = ProfileUserViewController()
                profileUserViewController.dataPost = result
                profileUserViewController.dataUser = user
                self.navigationController?.pushViewController(profileUserViewController, animated: true)
            } else {
                let friendViewController = FriendViewController()
                friendViewController.dataPost = result
                friendViewController.dataUser = user
                self.navigationController?.pushViewController(friendViewController, animated: true)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, dataPost: Post) {
        let detailPostViewController = DetailPostViewController()
        detailPostViewController.dataPost = dataPost
        self.navigationController?.pushViewController(detailPostViewController, animated: true)
    }
    
    func showListUser(listUser: [String]) {
        let listUserViewController = ListUserViewController()
        DataManager.shared.getListUser(listId: listUser) { result in
            listUserViewController.dataSources = result
            self.navigationController?.pushViewController(listUserViewController, animated: true)
        }
    }
    
    func showListComment(dataPost: Post) {
        let commentViewController = CommentViewController()
        commentViewController.dataPost = dataPost
        commentViewController.commentDelegate = self
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
    
}

//MARK: CommentViewControllerDelegate
extension HomeViewController: CommentViewControllerDelegate {
    func reloadComment(count: Int, post: Post) {
        guard let positionPost = Int(post.id!) else { return }
        let indexPath = IndexPath(row: 1, section: dataSources.count - positionPost)
        let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell
        cell?.countCommentButton.setTitle(String(count), for: .normal)
        self.tableView.reloadData()
    }
}

//MARK: TitleTableViewCellDelegate
extension HomeViewController: TitleTableViewCellDelegate {
    func presentViewController(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}

//MARK: UITabBarControllerDelegate
extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            DataManager.shared.getUserFromId(id: DataManager.shared.user.id!) {
                var data = DataManager.shared.user.listIdFollowing ?? []
                data.append(DataManager.shared.user.id!)
                DataManager.shared.getPostFromListId(listId: data) { result in
                    if self.dataSources.count != result.count {
                        self.dataSources = result
                        self.tableView.reloadData()
                    }
                }
            }
        case 3:
            NotificationCenter.default.post(name: Notification.Name("defaultNotify"), object: nil)
        case 4:
            let profileUserViewController = viewController as? ProfileUserViewController
            DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
                profileUserViewController?.dataPost = result
                DataManager.shared.setDataUser()
                profileUserViewController?.dataUser = DataManager.shared.user
                profileUserViewController?.collectionView.reloadData()
            }
        default:
            break
        }
    }
}
