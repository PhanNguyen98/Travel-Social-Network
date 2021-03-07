//
//  ProfileFriendTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 27/01/2021.
//

import UIKit

class ProfileFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    var isActive = true
    var dataUser = User()
    var listFriend = DataManager.shared.user.listIdFriends
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        if isActive {
            DataManager.shared.setDataUser()
            isActive = false
            addFriendButton.setTitle("Friend", for: .normal)
            if dataUser.listIdFriends!.first{ $0 == DataManager.shared.user.id } == nil {
                dataUser.listIdFriends?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataFriend(id: dataUser.id!, listFriend: dataUser.listIdFriends!)
            }
            if DataManager.shared.user.listIdFriends?.first{ $0 == dataUser.id} == nil {
                DataManager.shared.user.listIdFriends?.append(dataUser.id!)
                DataManager.shared.setDataFriend(id: DataManager.shared.user.id!, listFriend: DataManager.shared.user.listIdFriends!)
            }
        } else {
            DataManager.shared.setDataUser()
            isActive = true
            addFriendButton.setTitle("Add Friend", for: .normal)
            for index in 0..<dataUser.listIdFriends!.count {
                if dataUser.listIdFriends![index] == DataManager.shared.user.id {
                    dataUser.listIdFriends?.remove(at: index)
                    DataManager.shared.setDataFriend(id: dataUser.id!, listFriend: dataUser.listIdFriends!)
                }
            }
            for index in 0..<DataManager.shared.user.listIdFriends!.count {
                if DataManager.shared.user.listIdFriends?[index] == dataUser.id {
                    DataManager.shared.user.listIdFriends?.remove(at: index)
                    DataManager.shared.setDataFriend(id: DataManager.shared.user.id!, listFriend: DataManager.shared.user.listIdFriends!)
                    break
                }
            }
        }
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1
        nameLabel.underline()
        birthdayLabel.underline()
        placeLabel.underline()
        addFriendButton.layer.cornerRadius = 10
        addFriendButton.layer.masksToBounds = true
        addFriendButton.setTitle("Add Friend", for: .normal)
    }
    
    func setData(user: User) {
        if user.listIdFriends != nil {
            for item in user.listIdFriends! {
                if item == DataManager.shared.user.id {
                    addFriendButton.setTitle("Friend", for: .normal)
                    isActive = false
                }
            }
        }
        nameLabel.text = user.name
        birthdayLabel.text = user.birthday
        placeLabel.text = user.place
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: user.nameBackgroundImage!) { result in
            DispatchQueue.main.async() {
                self.backgroundImageView.image = result
            }
        }
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: user.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.image = result
            }
        }
    }
}
