//
//  DetailImageTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 08/03/2021.
//

import UIKit

class DetailImageTableViewCell: UITableViewCell {

    @IBOutlet weak var sightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sightImageView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadData(nameImage: String) {
        DataImageManager.shared.downloadImage(path: "post", nameImage: nameImage ) { result in
            DispatchQueue.main.async {
                self.sightImageView.kf.indicatorType = .activity
                self.sightImageView.kf.setImage(with: result)
            }
        }
    }
    
}
