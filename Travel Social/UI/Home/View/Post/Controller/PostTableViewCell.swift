//
//  PostTableViewCell.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit

//MARK: PostTableViewCellDelegate
protocol PostTableViewCellDelegate: class {
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, nameImage: String)
    func showListUser(listUser: [String])
    func showListComment(dataPost: Post)
}

class PostTableViewCell: UITableViewCell {

//MARK: Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentPostLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countHeartButton: UIButton!
    @IBOutlet weak var countCommentButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
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
        avatarImageView.image = nil
        collectionView.reloadData()
    }
    
//MARK: SetData
    func setdata(data: Post) {
        DataManager.shared.getUserFromId(id: data.idUser!) { result in
            DataImageManager.shared.downloadImage(path: "avatar", nameImage: result.nameImage!) { resultImage in
                self.avatarImageView.image = resultImage
            }
            self.nameLabel.text = result.name
        }
        if data.listIdHeart?.count != 0 {
            for item in data.listIdHeart! {
                if item == DataManager.shared.user.id {
                    heartButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                    isActive = false
                    break
                }
            }
        }
        timeLabel.text = data.date
        contentPostLabel.text = data.content
        listNameImage = data.listImage ?? [""]
        countHeartButton.setTitle(String(data.listIdHeart!.count), for: .normal)
        DataManager.shared.getCountComment(idPost: data.id!) { result in
            self.countCommentButton.setTitle("\(result) comment", for: .normal)
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
        heartButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        countHeartButton.setTitle("", for: .normal)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
//MARK: IBAction
    @IBAction func showListHeart(_ sender: Any) {
        guard let listUser = dataPost?.listIdHeart else { return }
        if listUser.count != 0 {
            cellDelegate?.showListUser(listUser: listUser)
        }
    }
    
    @IBAction func addHeart(_ sender: Any) {
        if isActive {
            isActive = false
            heartButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            if dataPost?.listIdHeart!.first(where: { $0 == DataManager.shared.user.id }) == nil {
                dataPost?.listIdHeart?.append(DataManager.shared.user.id!)
                DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: (dataPost?.listIdHeart)!)
                countHeartButton.setTitle(String((dataPost?.listIdHeart!.count)!), for: .normal)
            }
        } else {
            isActive = true
            heartButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            for index in 0..<(dataPost?.listIdHeart!.count)! {
                if DataManager.shared.user.id == dataPost?.listIdHeart?[index] {
                    dataPost?.listIdHeart?.remove(at: index)
                    DataManager.shared.setDataListIdHeart(id: (dataPost?.id!)!, listIdHeart: (dataPost?.listIdHeart)!)
                }
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
        self.cellDelegate?.collectionView(collectionView: collectionView, didSelectItemAt: indexPath, nameImage: listNameImage[indexPath.row])
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
        let width = UIScreen.main.bounds.width
        return CGSize(width: width - 20, height: (width - 20)*9/16 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}

