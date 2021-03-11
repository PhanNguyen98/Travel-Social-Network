//
//  PostCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countHeartLabel: UILabel!
    @IBOutlet weak var countCommentButton: UILabel!
    
    let colors = Colors()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setUI() {
        colors.gradientLayer.frame = self.infoView.bounds
        self.infoView.layer.insertSublayer(colors.gradientLayer, at:0)
        
        infoView.layer.cornerRadius = 10
        infoView.layer.masksToBounds = true
    }
    
    func setData(data: Post) {
        DataImageManager.shared.downloadImage(path: "post", nameImage: data.listImage?[0] ?? "") { result in
            DispatchQueue.main.async {
                self.imageView.image = result
            }
        }
        countHeartLabel.text = String(data.listIdHeart?.count ?? 0)
        DataManager.shared.getCountComment(idPost: data.id!) { result in
            self.countCommentButton.text = String(result)
        }
    }

}
