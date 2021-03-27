//
//  PostCollectionViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var countCommentLabel: UILabel!
    @IBOutlet weak var countHeartLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    var listNameImage = [String]()
    var dataPost: Post?
    var isActive = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.reloadData()
        self.avatarImageView.image = nil
    }
    
//MARK: SetCollectionView
    func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func setUI() {
        self.dropShadow(color: UIColor.systemGray3, opacity: 0.3, offSet: .zero, radius: 10, scale: true)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.layer.borderWidth = 0.5
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        
    }
    
    func setData(data: Post) {
        if let idUser = data.idUser {
            DataManager.shared.getUserFromId(id: idUser) { result in
                DispatchQueue.main.async {
                    self.avatarImageView.kf.indicatorType = .activity
                    self.avatarImageView.kf.setImage(with: URL(string: result.nameImage!))
                }
                self.nameLabel.text = result.name
            }
            placeLabel.text = data.place ?? ""
            placeLabel.text?.append("  ")
            placeLabel.text?.append(data.date!)
            contentLabel.text = data.content
        }
        if data.listIdHeart?.first(where: { $0 == DataManager.shared.user.id}) != nil {
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            isActive = false
        } else {
            isActive = true
            heartButton.setImage(UIImage(named: "heart empty"), for: .normal)
        }
        self.listNameImage = data.listImage!
        countHeartLabel.text = String(data.listIdHeart?.count ?? 0)
        DataManager.shared.getCountComment(idPost: data.id!) { result in
            self.countCommentLabel.text = String(result)
        }
    }
    
    @IBAction func addHeart(_ sender: Any) {
        if isActive {
            isActive = false
            heartButton.setImage(UIImage(named: "heart fill"), for: .normal)
            if dataPost?.listIdHeart!.first(where: { $0 == DataManager.shared.user.id }) == nil {
                dataPost?.listIdHeart?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: dataPost?.listIdHeart ?? [])
                countHeartLabel.text = String(dataPost?.listIdHeart!.count ?? 0)
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
            countHeartLabel.text = String(dataPost?.listIdHeart!.count ?? 0)
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension PostCollectionViewCell: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource
extension PostCollectionViewCell: UICollectionViewDataSource {
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
extension PostCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
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
