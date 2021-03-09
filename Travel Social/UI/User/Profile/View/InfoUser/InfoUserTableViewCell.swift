//
//  InfoUserTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 26/01/2021.
//

import UIKit

protocol InfoUserTableViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
    func sendDataPost(dataPost: [Post])
    func sendDataFriend(dataFriend: [User])
}

class InfoUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    weak var cellDelegate: InfoUserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.editVCDelegate = self
        self.cellDelegate?.pushViewController(viewController: editProfileViewController)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        avatarImageView.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.masksToBounds = true
    }
    
    func setData(item: User) {
        nameLabel.text = item.name
        birthdayLabel.text = item.birthday
        placeLabel.text = item.place
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
    }
    
    @IBAction func loadData(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            DataManager.shared.getPostFromId(idUser: DataManager.shared.user.id!) { result in
                self.cellDelegate?.sendDataPost(dataPost: result)
            }
        case 1:
            DataManager.shared.setDataUser()
            DataManager.shared.getUserFromListId(listId: DataManager.shared.user.listIdFriends ?? []) { result in
                self.cellDelegate?.sendDataFriend(dataFriend: result)
            }
        default:
            break
        }
    }
    
}

extension InfoUserTableViewCell: EditProfileViewControllerDelegate {
    
    func changeAvatarImage(image: UIImage?) {
        avatarImageView.image = image
    }
    
    func changeBackgroundImage(image: UIImage?) {
        backgroundImageView.image = image
    }
    
}
