//
//  CreatePostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit
import Kingfisher

class CreatePostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setData(item: User) {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: result)
            }
        }
    }
    
}
