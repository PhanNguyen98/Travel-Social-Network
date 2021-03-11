//
//  FriendCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setData(data: User) {
        nameLabel.text = data.name
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: data.nameImage!) { result in
            DispatchQueue.main.async {
                self.imageView.image = result
            }
        }
    }

}
