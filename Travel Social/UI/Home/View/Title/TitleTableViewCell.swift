//
//  TitleTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 08/03/2021.
//

import UIKit

protocol TitleTableViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
    func presentViewController(viewController: UIViewController)
}

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var cellDelegate: TitleTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setSearchBar()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search User"
    }
    
    func setUI() {
        let colorTop =  UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 195.0/255.0, green: 226.0/255.0, blue: 245.0/255.0, alpha: 0.5).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.contentView.bounds
                
        self.contentView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func showNotification(_ sender: Any) {
        let notifyViewController = NotifyViewController()
        self.cellDelegate?.pushViewController(viewController: notifyViewController)
    }
    
}

extension TitleTableViewCell: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let keySearchViewController = KeySearchViewController()
        let navigationController = UINavigationController(rootViewController: keySearchViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        searchBar.endEditing(true)
        self.cellDelegate?.presentViewController(viewController: navigationController)
    }
}
