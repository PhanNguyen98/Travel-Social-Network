//
//  InfoUserCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 10/03/2021.
//

import UIKit
import Kingfisher

protocol InfoUserCollectionViewCellDelegate: class {
    func presentViewController(viewController: UIViewController)
    func sendDataPost(dataPost: [Post])
    func sendDataUser(dataFriend: [User])
}

class InfoUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var jobLabel: UILabel!
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
            if DataManager.shared.user.listIdFollowers?.count != 0 {
                DataManager.shared.getUserFromListId(listId: DataManager.shared.user.listIdFollowers!) { result in
                    self.cellDelegate?.sendDataUser(dataFriend: result)
                }
            } else {
                self.cellDelegate?.sendDataUser(dataFriend: [User]())
            }
        case 2:
            DataManager.shared.setDataUser()
            if DataManager.shared.user.listIdFollowing!.count != 0 {
                DataManager.shared.getUserFromListId(listId: DataManager.shared.user.listIdFollowing!) { result in
                    self.cellDelegate?.sendDataUser(dataFriend: result)
                }
            } else {
                self.cellDelegate?.sendDataUser(dataFriend: [User]())
            }
        default:
            break
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.editVCDelegate = self
        self.cellDelegate?.presentViewController(viewController: editProfileViewController)
    }
    
    func setUI() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
        
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
        DispatchQueue.main.async() {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: URL(string: item.nameImage!))
        }
    }
    
}

extension InfoUserCollectionViewCell: EditProfileViewControllerDelegate {

    func changeAvatarImage(image: UIImage?) {
        avatarImageView.image = image
    }
    
}
    
