//
//  InfoUserCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 10/03/2021.
//

import UIKit

protocol InfoUserCollectionViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
    func sendDataPost(dataPost: [Post])
    func sendDataFriend(dataFriend: [User])
}

class InfoUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var countPostButton: UIButton!
    @IBOutlet weak var countFriendButton: UIButton!
    @IBOutlet weak var countPostLabel: UILabel!
    @IBOutlet weak var countFriendLabel: UILabel!
    @IBOutlet weak var titleContentLabel: UILabel!
    
    weak var cellDelegate: InfoUserCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.editVCDelegate = self
        self.cellDelegate?.pushViewController(viewController: editProfileViewController)
    }
    @IBAction func showListPost(_ sender: Any) {
        titleContentLabel.text = "My Posts"
        DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
            self.cellDelegate?.sendDataPost(dataPost: result)
        }
    }
    
    @IBAction func showListFriend(_ sender: Any) {
        titleContentLabel.text = "My Friends"
        DataManager.shared.setDataUser()
        DataManager.shared.getUserFromListId(listId: DataManager.shared.user.listIdFriends ?? []) { result in
            self.cellDelegate?.sendDataFriend(dataFriend: result)
        }
    }
    func setUI() {
        self.setBackgroundImage(img: UIImage(named: "background")!)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
        
        backgroundImageView.layer.cornerRadius = 10
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2 - 5
        avatarImageView.layer.borderColor = UIColor.systemGray2.cgColor
        avatarImageView.layer.borderWidth = 1.5
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.masksToBounds = true
        
        countPostButton.layer.cornerRadius = 10
        countFriendButton.layer.cornerRadius = 10
    }
    
    func setData(item: User, countPost: Int) {
        nameLabel.text = item.name
        birthdayLabel.text = item.birthday
        placeLabel.text = item.place
        jobLabel.text = item.job
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameBackgroundImage!) { result in
            DispatchQueue.main.async() {
                self.backgroundImageView.image = result
            }
        }
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.image = result
            }
        }
        DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
            self.countPostLabel.text = String(result.count)
        }
        self.countFriendLabel.text = String(DataManager.shared.user.listIdFriends?.count ?? 0)
    }
    
}

extension InfoUserCollectionViewCell: EditProfileViewControllerDelegate {
    
    func changeAvatarImage(image: UIImage?) {
        avatarImageView.image = image
    }
    
    func changeBackgroundImage(image: UIImage?) {
        backgroundImageView.image = image
    }
    
}
    
