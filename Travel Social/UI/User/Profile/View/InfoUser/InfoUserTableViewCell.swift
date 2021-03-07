//
//  InfoUserTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 26/01/2021.
//

import UIKit

protocol InfoUserTableViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
}

class InfoUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
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
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1
        nameLabel.underline()
        birthdayLabel.underline()
        placeLabel.underline()
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
    
}

extension InfoUserTableViewCell: EditProfileViewControllerDelegate {
    
    func changeAvatarImage(image: UIImage?) {
        avatarImageView.image = image
    }
    
    func changeBackgroundImage(image: UIImage?) {
        backgroundImageView.image = image
    }
    
}
