//
//  DetailPostViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 19/03/2021.
//

import UIKit

class DetailPostViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dataPost = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
    }

//MARK: SetTableView
    func setTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TitlePostTableViewCell", bundle: nil), forCellReuseIdentifier: "TitlePostTableViewCell")
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
    }
    
    func setNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITableViewDelegate
extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailImageViewController = DetailImageViewController()
        detailImageViewController.nameImage = dataPost.listImage![indexPath.section - 1]
        self.navigationController?.pushViewController(detailImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
}

//MARK: UITableViewDataSource
extension DetailPostViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let countImage = dataPost.listImage?.count else {
            return 1
        }
        return countImage + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitlePostTableViewCell", for: indexPath) as? TitlePostTableViewCell else {
                return TitlePostTableViewCell()
            }
            cell.selectionStyle = .none
            cell.setData(data: dataPost)
            cell.dataPost = dataPost
            cell.cellDelegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else { return ImageTableViewCell()
            }
            cell.selectionStyle = .none
            cell.setData(url: dataPost.listImage![indexPath.section - 1])
            return cell
        }
    }
    
}

//MARK: TitlePostTableViewCellDelegate
extension DetailPostViewController: TitlePostTableViewCellDelegate {
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
    
    func showComment(dataPost: Post) {
        let commentViewController = CommentViewController()
        commentViewController.dataPost = dataPost
        DataManager.shared.getComment(idPost: dataPost.id!) { result in
            commentViewController.dataSources = result
            self.navigationController?.pushViewController(commentViewController, animated: true)
        }
    }
}
