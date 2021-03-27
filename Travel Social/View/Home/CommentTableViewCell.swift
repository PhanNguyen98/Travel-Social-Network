//
//  CommentTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/02/2021.
//

import UIKit
import Kingfisher

protocol CommentTableViewCellDelegate: class {
    func showProfile(user: User)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    
    var dataComment = Comment()
    weak var cellDelegate: CommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarButton.imageView?.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let idUser = dataComment.idUser {
            DataManager.shared.getUserFromId(id: idUser) { result in
                self.cellDelegate?.showProfile(user: result)
            }
        }
    }
    
    func setUI() {
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.layer.cornerRadius = avatarButton.frame.height / 2
        avatarButton.layer.cornerRadius = avatarButton.frame.height / 2
        avatarButton.layer.borderWidth = 1
        avatarButton.layer.borderColor = UIColor.systemGray3.cgColor
        avatarButton.layer.masksToBounds = true
    }
    
    func setData(comment: Comment) {
        DataManager.shared.getUserFromId(id: comment.idUser!) { result in
            DispatchQueue.main.async {
                self.avatarButton.imageView?.kf.indicatorType = .activity
                self.avatarButton.kf.setImage(with: URL(string: result.nameImage!), for: .normal)
            }
            self.nameButton.setTitle(result.name, for: .normal)
        }
        commentLabel.text = comment.content
    }
    
}
