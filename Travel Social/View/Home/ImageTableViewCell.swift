//
//  ImageTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 19/03/2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var sightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(url: String) {
        DispatchQueue.main.async {
            self.sightImageView.kf.indicatorType = .activity
            self.sightImageView.kf.setImage(with: URL(string: url))
        }
    }
    
}
