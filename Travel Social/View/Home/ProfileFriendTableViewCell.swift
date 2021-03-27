//
//  ProfileFriendTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 27/01/2021.
//

import UIKit
import Kingfisher

class ProfileFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var jobLabel: UILabel!
    
    var isActive = true
    var dataUser = User()
    var listFriend = DataManager.shared.user.listIdFollowers
    
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
            addFriendButton.setTitle("Unfollow", for: .normal)
            if dataUser.listIdFollowers!.first(where: { $0 == DataManager.shared.user.id }) == nil {
                dataUser.listIdFollowers?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataFollowers(id: dataUser.id!, listIdFollowers: dataUser.listIdFollowers!)
            }
            if DataManager.shared.user.listIdFollowing?.first(where: { $0 == dataUser.id}) == nil {
                DataManager.shared.user.listIdFollowing?.append(dataUser.id!)
                DataManager.shared.setDataFollowing(id: DataManager.shared.user.id!, listIdFollowing: DataManager.shared.user.listIdFollowing!)
            }
            let notify = Notify()
            notify.id = dataUser.id ?? ""
            notify.idFriend = DataManager.shared.user.id ?? ""
            notify.type = "follow"
            let idDocument = notify.id + notify.type + notify.idFriend
            DataManager.shared.setDataNotify(data: notify, idDocument: idDocument)
        } else {
            DataManager.shared.setDataUser()
            isActive = true
            addFriendButton.setTitle("Follow", for: .normal)
            if let index = dataUser.listIdFollowers?.firstIndex(of: DataManager.shared.user.id!) {
                dataUser.listIdFollowers?.remove(at: index)
                DataManager.shared.setDataFollowers(id: dataUser.id!, listIdFollowers: dataUser.listIdFollowers!)
            }
            if let index = DataManager.shared.user.listIdFollowing?.firstIndex(of: dataUser.id!) {
                DataManager.shared.user.listIdFollowing?.remove(at: index)
                DataManager.shared.setDataFollowing(id: DataManager.shared.user.id!, listIdFollowing: DataManager.shared.user.listIdFollowing!)
            }
        }
        DataManager.shared.getUserFromId(id: DataManager.shared.user.id!) {
        }
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2 - 2
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        avatarImageView.layer.borderWidth = 1
       
        addFriendButton.layer.cornerRadius = 10
        addFriendButton.layer.masksToBounds = true
        addFriendButton.setTitle("Follow", for: .normal)
    }
    
    func setData(user: User) {
        if user.listIdFollowers != nil {
            for item in user.listIdFollowers! {
                if item == DataManager.shared.user.id {
                    addFriendButton.setTitle(" Unfollow", for: .normal)
                    isActive = false
                }
            }
        }
        jobLabel.text = user.job
        nameLabel.text = user.name
        birthdayLabel.text = user.birthday
        placeLabel.text = user.place
        DispatchQueue.main.async() {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: URL(string: user.nameImage!))
        }
    }
}
