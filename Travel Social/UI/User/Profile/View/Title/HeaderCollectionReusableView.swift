//
//  HeaderCollectionReusableView.swift
//  Travel Social
//
//  Created by Phan Nguyen on 10/03/2021.
//

import UIKit

protocol HeaderCollectionReusableViewDelegate: class {
    func presentAlertController(alertController: UIAlertController)
    func popViewController()
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    
    weak var cellDelegate: HeaderCollectionReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func showSetting(_ sender: Any) {
        self.cellDelegate?.presentAlertController(alertController: setting())
    }
    
    func setting() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { _ in
            self.cellDelegate?.popViewController()
        }
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.pruneNegativeWidthConstraints()
        return alertController
    }
    
}
