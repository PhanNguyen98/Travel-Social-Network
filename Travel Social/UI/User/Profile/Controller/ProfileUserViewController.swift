//
//  FrofileUserViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 10/03/2021.
//

import UIKit

class ProfileUserViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataPost = [Post]()
    var dataFriend = [User]()
    var dataUser = DataManager.shared.user
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setNavigationBar()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        dataUser = DataManager.shared.user
        dataFriend = [User]()
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setViewSegment()
    }
    
//MARK: Set Navigationbar
    func setNavigationBar() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"option"), for: .normal)
        menuBtn.imageView?.contentMode = .scaleAspectFill
        menuBtn.addTarget(self, action: #selector(showOption), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBtn)
    }
    
//MARK: SetData
    func setData() {
        DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
            self.dataPost = result
            self.collectionView.reloadData()
        }
    }
    
    func setting() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { _ in
            self.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.pruneNegativeWidthConstraints()
        return alertController
    }
    
    @objc func showOption() {
        self.navigationController?.present(setting(), animated: true, completion: nil)
    }
    
//MARK: SetCollectionView
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InfoUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InfoUserCollectionViewCell")
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(UINib(nibName: "FriendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendCollectionViewCell")
    }
    
    func setViewSegment() {
        DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
            self.dataPost = result
        }
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? InfoUserCollectionViewCell else {
            return
        }
        cell.segmentedControl.selectedSegmentIndex = 0
    }

}

//MARK: UICollectionViewDelegate
extension ProfileUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let commentViewController = CommentViewController()
            commentViewController.dataPost = dataPost[dataPost.count - indexPath.row - 1]
            self.navigationController?.pushViewController(commentViewController, animated: true)
        case 2:
            let friendViewController = FriendViewController()
            friendViewController.dataUser = dataFriend[indexPath.row]
            DataManager.shared.getPostFromId(idUser: dataFriend[indexPath.row].id ?? "") { result in
                friendViewController.dataPost = result
                self.navigationController?.pushViewController(friendViewController, animated: true)
            }
        default:
            break
        }
    }
    
}

//MARK:: UICollectionViewDataSource
extension ProfileUserViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return dataPost.count
        default:
            return dataFriend.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoUserCollectionViewCell", for: indexPath) as? InfoUserCollectionViewCell else { return InfoUserCollectionViewCell() }
            cell.cellDelegate = self
            cell.setData(item: dataUser, countPost: dataPost.count)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as? PostCollectionViewCell else { return PostCollectionViewCell() }
            cell.setData(data: dataPost[dataPost.count - indexPath.row - 1])
            cell.dataPost = dataPost[dataPost.count - indexPath.row - 1]
            cell.commentButton.isUserInteractionEnabled = false
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as? FriendCollectionViewCell else { return FriendCollectionViewCell() }
            cell.setData(data: dataFriend[indexPath.row])
            return cell
        }
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 390)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: 435)
        default:
            return CGSize(width: collectionView.bounds.width/2 - 30, height: collectionView.bounds.width/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        case 1:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default:
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}

//MARK: InfoUserCollectionViewCellDelegate
extension ProfileUserViewController: InfoUserCollectionViewCellDelegate {
    func sendDataPost(dataPost: [Post]) {
        self.dataPost = dataPost
        self.dataFriend = [User]()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func sendDataUser(dataFriend: [User]) {
        self.dataFriend = dataFriend
        self.dataPost = [Post]()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func presentViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
