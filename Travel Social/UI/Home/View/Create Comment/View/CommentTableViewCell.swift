//
//  CommentTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/02/2021.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        avatarImageView.layer.masksToBounds = true
    }
    
    func setData(comment: Comment) {
        DataManager.shared.getUserFromId(id: comment.idUser!) { result in
            DataImageManager.shared.downloadImage(path: "avatar", nameImage: result.nameImage!) { result in
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: result)
            }
            self.nameLabel.text = result.name
        }
        commentLabel.text = comment.content
    }
    
}
