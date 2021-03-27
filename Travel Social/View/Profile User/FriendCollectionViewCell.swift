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
        setUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setUI(){
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func setData(data: User) {
        nameLabel.text = data.name
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: data.nameImage!))
        }
    }

}
