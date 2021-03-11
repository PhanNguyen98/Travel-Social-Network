//
//  CreatePostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit

class CreatePostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setBackground() {
        let colorTop = UIColor(red: 195.0/255.0, green: 226.0/255.0, blue: 245.0/255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 141.0/255.0, green: 201.0/255.0, blue: 238.0/255.0, alpha: 0.5).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.contentView.bounds
                
        self.contentView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setData(item: User) {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.avatarImageView.image = result
            }
        }
    }
    
}
