//
//  UserTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/01/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    func setData(item: User) {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            self.avatarImageView.image = result
        }
        nameLabel.text = item.name
    }
    
}
