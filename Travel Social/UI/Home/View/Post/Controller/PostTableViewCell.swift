//
//  PostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit
import Kingfisher

//MARK: PostTableViewCellDelegate
protocol PostTableViewCellDelegate: class {
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, dataPost: Post)
    func showListUser(listUser: [String])
    func showListComment(dataPost: Post)
    func showProfile(user: User)
}

class PostTableViewCell: UITableViewCell {

//MARK: Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentPostLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countHeartButton: UIButton!
    @IBOutlet weak var countCommentButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    
    var listNameImage = [String]()
    weak var cellDelegate: PostTableViewCellDelegate?
    var isActive = true
    var dataPost: Post?

//MARK:
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarButton.imageView?.image = nil
        collectionView.reloadData()
    }
    
//MARK: SetData
    func setdata(data: Post) {
        DataManager.shared.getUserFromId(id: data.idUser!) { result in
            DispatchQueue.main.async {
                self.avatarButton.imageView?.kf.indicatorType = .activity
                self.avatarButton.kf.setImage(with: URL(string: result.nameImage!), for: .normal)
            }
            self.nameButton.setTitle(result.name, for: .normal)
        }
        if data.listIdHeart?.first(where: { $0 == DataManager.shared.user.id}) != nil {
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            isActive = false
        } else {
            isActive = true
            heartButton.setImage(UIImage(named: "heart empty"), for: .normal)
        }
        timeLabel.text = data.place ?? ""
        timeLabel.text?.append("  ")
        timeLabel.text?.append(data.date!)
        contentPostLabel.text = data.content
        listNameImage = data.listImage ?? [""]
        countHeartButton.setTitle(String(data.listIdHeart?.count ?? 0), for: .normal)
        DataManager.shared.getCountComment(idPost: data.id!) { result in
            self.countCommentButton.setTitle("\(result)", for: .normal)
        }
    }

//MARK: SetCollectionView
    func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }

//MARK: SetUI
    func setUI() {
        heartButton.setImage(UIImage(named: "heart empty"), for: .normal)
        countHeartButton.setTitle("", for: .normal)
        
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.layer.cornerRadius = avatarButton.frame.height / 2
        avatarButton.layer.cornerRadius = avatarButton.frame.height / 2
        avatarButton.layer.borderWidth = 1
        avatarButton.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
//MARK: IBAction
    @IBAction func showProfile(_ sender: Any) {
        if let idUser = dataPost?.idUser {
            DataManager.shared.getUserFromId(id: idUser) { result in
                self.cellDelegate?.showProfile(user: result)
            }
        }
    }
    
    @IBAction func showListHeart(_ sender: Any) {
        guard let listUser = dataPost?.listIdHeart else { return }
        if listUser.count != 0 {
            cellDelegate?.showListUser(listUser: listUser)
        }
    }
    
    @IBAction func addHeart(_ sender: Any) {
        if isActive {
            isActive = false
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            if dataPost?.listIdHeart?.first(where: { $0 == DataManager.shared.user.id }) == nil {
                dataPost?.listIdHeart?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: dataPost?.listIdHeart ?? [])
                countHeartButton.setTitle(String((dataPost?.listIdHeart!.count)!), for: .normal)
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
            if let index = dataPost?.listIdHeart?.firstIndex(of: DataManager.shared.user.id ?? "") {
                dataPost?.listIdHeart?.remove(at: index)
                DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: dataPost?.listIdHeart ?? [])
            }
            countHeartButton.setTitle(String((dataPost?.listIdHeart!.count)!), for: .normal)
        }
    }
    
    @IBAction func addComment(_ sender: Any) {
        cellDelegate?.showListComment(dataPost: dataPost!)
    }
    
}

//MARK: UICollectionViewDelegate
extension PostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellDelegate?.collectionView(collectionView: collectionView, didSelectItemAt: indexPath, dataPost: dataPost ?? Post())
    }
}

//MARK: UICollectionViewDataSource
extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listNameImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell  else { return ImageCollectionViewCell() }
        cell.setData(nameImage: listNameImage[indexPath.row])
        return cell
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if listNameImage.count == 1 {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 20)
        }
        return CGSize(width: (collectionView.bounds.width - 20)*2/3, height: collectionView.bounds.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if listNameImage.count == 1 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}

