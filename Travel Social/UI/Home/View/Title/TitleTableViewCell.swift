//
//  TitleTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 08/03/2021.
//

import UIKit
import Kingfisher

protocol TitleTableViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
    func presentViewController(viewController: UIViewController)
}

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var createPostButton: UIButton!
    
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
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        
        createPostButton.layer.cornerRadius = 15
        createPostButton.layer.masksToBounds = true
    }
    
    func setData(item: User) {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: result)
            }
        }
    }
    
    @IBAction func showCreatePost(_ sender: Any) {
        let createPostViewController = CreatePostViewController()
        createPostViewController.createPostDelegate = self
        let navigationController = UINavigationController(rootViewController: createPostViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.cellDelegate?.presentViewController(viewController: navigationController)
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

extension TitleTableViewCell: CreatePostViewControllerDelegate {
    func presentAlertController(alertController: UIAlertController) {
        self.cellDelegate?.presentViewController(viewController: alertController)
    }
}
