//
//  TitleTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 08/03/2021.
//

import UIKit
import Kingfisher

protocol TitleTableViewCellDelegate: class {
    func presentViewController(viewController: UIViewController)
}

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchButton: UIButton!
    
    weak var cellDelegate: TitleTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func presentSearchViewController(_ sender: Any) {
        let keySearchViewController = KeySearchViewController()
        let navigationController = UINavigationController(rootViewController: keySearchViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.cellDelegate?.presentViewController(viewController: navigationController)
    }
    
}
