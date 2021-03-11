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
    let colors = Colors()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    @IBAction func showSetting(_ sender: Any) {
        self.cellDelegate?.presentAlertController(alertController: setting())
    }
    
    func setUI() {
        colors.gradientLayer.frame = self.contentView.bounds
        self.contentView.layer.insertSublayer(colors.gradientLayer, at:0)
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
