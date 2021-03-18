//
//  FriendCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit
import Kingfisher

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dropShadow(color: UIColor.systemGray3, opacity: 0.3, offSet: .zero, radius: 10, scale: true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setData(data: User) {
        nameLabel.text = data.name
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: data.nameImage!) { result in
            DispatchQueue.main.async {
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(with: result)
            }
        }
    }

}
