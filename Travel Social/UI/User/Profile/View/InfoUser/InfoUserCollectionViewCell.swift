//
//  InfoUserCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 10/03/2021.
//

import UIKit
import Kingfisher

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
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    weak var cellDelegate: InfoUserCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    @IBAction func loadData(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
                self.cellDelegate?.sendDataPost(dataPost: result)
            }
        case 1:
            DataManager.shared.setDataUser()
            if DataManager.shared.user.listIdFriends?.count != 0 {
                DataManager.shared.getUserFromListId(listId: DataManager.shared.user.listIdFriends!) { result in
                    self.cellDelegate?.sendDataFriend(dataFriend: result)
                }
            } else {
                self.cellDelegate?.sendDataFriend(dataFriend: [User]())
            }
        default:
            break
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.editVCDelegate = self
        self.cellDelegate?.pushViewController(viewController: editProfileViewController)
    }
    
    func setUI() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
        
        profileView.layer.cornerRadius = 15
        profileView.layer.masksToBounds = true
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2 - 3
        avatarImageView.layer.borderColor = UIColor.systemGray2.cgColor
        avatarImageView.layer.borderWidth = 1.5
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.masksToBounds = true
        
        segmentedControl.layer.cornerRadius = 10
    }
    
    func setData(item: User, countPost: Int) {
        nameLabel.text = item.name
        birthdayLabel.text = item.birthday
        placeLabel.text = item.place
        jobLabel.text = item.job
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: result)
            }
        }
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
    
