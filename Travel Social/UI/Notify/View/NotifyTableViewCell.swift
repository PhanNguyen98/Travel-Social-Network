//
//  NotifyTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 02/03/2021.
//

import UIKit
import Kingfisher

class NotifyTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        avatarImageView.layer.masksToBounds = true
    }
    
    func setData(data: Notify) {
        DataManager.shared.getUserFromId(id: data.idFriend) { result in
            DispatchQueue.main.async {
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: URL(string: result.nameImage!))
            }
            switch data.type {
            case "comment":
                self.contentLabel.text = result.name ?? ""
                self.contentLabel.text?.append(" was commented " + data.content)
                self.contentLabel.text?.append(" in your post")
            case "follow":
                self.contentLabel.text = result.name ?? ""
                self.contentLabel.text?.append(" was followed you")
            default:
                self.contentLabel.text = result.name ?? ""
                self.contentLabel.text?.append(" was added heart in your post")
            }
        }
    }
    
}
