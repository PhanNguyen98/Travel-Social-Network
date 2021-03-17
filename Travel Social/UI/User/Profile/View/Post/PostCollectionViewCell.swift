//
//  PostCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.layer.borderWidth = 0.5
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setData(data: Post) {
        if let idUser = data.idUser {
            DataManager.shared.getUserFromId(id: idUser) { result in
                DataImageManager.shared.downloadImage(path: "avatar", nameImage: result.nameImage ?? "") { resultUrl in
                    self.avatarImageView.kf.indicatorType = .activity
                    self.avatarImageView.kf.setImage(with: resultUrl)
                }
                self.nameLabel.text = result.name
            }
            placeLabel.text = data.place ?? ""
            placeLabel.text?.append("  ")
            placeLabel.text?.append(data.date!)
            contentLabel.text = data.content
        }
    }

}
