//
//  ListFriendTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 26/01/2021.
//

import UIKit

protocol ListFriendTableViewCellDelegate: class {
    func showListFriend(viewController: UIViewController)
}

class ListFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var countFriendLabel: UILabel!
    @IBOutlet weak var friendsButton: UIButton!
    
    weak var cellDelegate: ListFriendTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func showListFriend(_ sender: Any) {
        let listFriendViewController = ListFriendViewController()
        self.cellDelegate?.showListFriend(viewController: listFriendViewController)
    }
    
    func setUI() {
        countFriendLabel.underline()
        
        friendsButton.layer.cornerRadius = 10
        friendsButton.layer.masksToBounds = true
    }
    
}
