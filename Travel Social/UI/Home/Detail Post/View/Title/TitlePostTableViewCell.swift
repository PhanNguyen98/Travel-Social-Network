//
//  TitlePostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 19/03/2021.
//

import UIKit
import Kingfisher

protocol TitlePostTableViewCellDelegate: class {
    func showProfile(user: User)
    func showComment(dataPost: Post)
}

class TitlePostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var countHeartLabel: UILabel!
    @IBOutlet weak var countCommentLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    weak var cellDelegate: TitlePostTableViewCellDelegate?
    var dataPost: Post?
    var isActive = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        avatarButton.layer.cornerRadius = avatarButton.frame.height/2
        avatarButton.layer.borderWidth = 0.5
        avatarButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setData(data: Post) {
        DataManager.shared.getUserFromId(id: data.idUser!) { result in
            DispatchQueue.main.async {
                self.avatarButton.imageView?.kf.indicatorType = .activity
                self.avatarButton.kf.setImage(with: URL(string: result.nameImage ?? ""), for: .normal)
            }
            self.nameButton.setTitle(result.name, for: .normal)
        }
        if data.listIdHeart?.first(where: { $0 == DataManager.shared.user.id}) != nil {
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            isActive = false
        } else {
            heartButton.setImage(UIImage(named: "heart empty"), for: .normal)
        }
        placeLabel.text = data.place
        placeLabel.text?.append(" ")
        placeLabel.text?.append(data.date!)
        contentLabel.text = data.content
        countHeartLabel.text = String(data.listIdHeart?.count ?? 0)
        DataManager.shared.getCountComment(idPost: data.id!) { result in
            self.countCommentLabel.text = String(result)
        }
    }
    
    @IBAction func showComment(_ sender: Any) {
        self.cellDelegate?.showComment(dataPost: dataPost!)
    }
    
    @IBAction func addHeart(_ sender: Any) {
        if isActive {
            isActive = false
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            if dataPost?.listIdHeart!.first(where: { $0 == DataManager.shared.user.id }) == nil {
                dataPost?.listIdHeart?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: (dataPost?.listIdHeart)!)
                countHeartLabel.text = String((dataPost?.listIdHeart!.count)!)
            }
            if dataPost?.idUser != DataManager.shared.user.id {
                let notify = Notify()
                notify.id = dataPost?.idUser ?? ""
                notify.idPost = dataPost?.id ?? ""
                notify.idFriend = DataManager.shared.user.id ?? ""
                notify.type = "heart"
                let idDocument = notify.idFriend + notify.type + notify.idPost
                DataManager.shared.setDataNotify(data: notify, idDocument: idDocument)
            }
        } else {
            isActive = true
            heartButton.setImage(UIImage(named: "heart empty"), for: .normal)
            for index in 0..<(dataPost?.listIdHeart!.count)! {
                if DataManager.shared.user.id == dataPost?.listIdHeart?[index] {
                    dataPost?.listIdHeart?.remove(at: index)
                    DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: (dataPost?.listIdHeart)!)
                    break
                }
            }
            countHeartLabel.text = String((dataPost?.listIdHeart!.count)!)
        }
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let idUser = dataPost?.idUser {
            DataManager.shared.getUserFromId(id: idUser) { result in
                self.cellDelegate?.showProfile(user: result)
            }
        }
    }
    
}
