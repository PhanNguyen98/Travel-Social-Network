//
//  UserTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/01/2021.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2 - 2
    }
    
    func setData(item: User) {
        DispatchQueue.main.async {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: URL(string: item.nameImage!))
        }
        nameLabel.text = item.name
        jobLabel.text = item.job
    }
    
}
