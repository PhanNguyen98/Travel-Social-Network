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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//MARK: SetCollectionView
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InfoUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InfoUserCollectionViewCell")
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderCollectionReusableView.self)")
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
            navigationController?.pushViewController(friendViewController, animated: true)
        default:
            break
        }
    }
    
}

//MARK:: UICollectionViewDataSource
extension ProfileUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderCollectionReusableView.self)", for: indexPath) as? HeaderCollectionReusableView else {
                fatalError("Invalid view type")
            }
            reusableView.cellDelegate = self
            return reusableView
        default:
            assert(false, "Invalid element type")
        }
    }
    
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return ImageCollectionViewCell() }
            cell.setData(nameImage: dataPost[dataPost.count - indexPath.row - 1].listImage?[0] ?? "")
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return ImageCollectionViewCell() }
            cell.setData(nameImage: dataFriend[indexPath.row].nameImage ?? "")
            return cell
        }
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0 :
            return CGSize(width: collectionView.frame.width, height: 60)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 610)
        default:
            return CGSize(width: collectionView.bounds.width/2 - 30, height: collectionView.bounds.width/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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
    
    func sendDataFriend(dataFriend: [User]) {
        self.dataFriend = dataFriend
        self.dataPost = [Post]()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK:
extension ProfileUserViewController: HeaderCollectionReusableViewDelegate {
    func presentAlertController(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
