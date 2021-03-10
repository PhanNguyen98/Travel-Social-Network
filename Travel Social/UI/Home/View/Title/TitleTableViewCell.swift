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
        self.setBackgroundImage(img: UIImage(named: "background")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search User"
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
