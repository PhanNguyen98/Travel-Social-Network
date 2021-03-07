//
//  CreatePostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit

protocol CreatePostTableViewCellDelegate: class {
    func pushViewController(viewController: UIViewController)
}

class CreatePostTableViewCell: UITableViewCell {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    weak var cellDelegate: CreatePostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        postButton.layer.cornerRadius = postButton.frame.height / 2
        postButton.layer.borderWidth = 0.2
        postButton.layer.borderColor = UIColor.black.cgColor
        postButton.layer.masksToBounds = true
    }
    
    @IBAction func createPost(_ sender: Any) {
        let createPostViewController = CreatePostViewController()
        cellDelegate?.pushViewController(viewController: createPostViewController)
    }
    
    func setData(item: User) {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: item.nameImage!) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.avatarImageView.image = result
            }
        }
    }
    
}
