//
//  PostViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit
import OpalImagePicker
import Photos
import SVProgressHUD
import Kingfisher

class CreatePostViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createPostButton: UIButton!
    
    var resultImagePicker = [PHAsset]()
    var dataPost = Post()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
        Utilities.checkPhotoLibrary()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setDataUser()
    }
    
//MARK: SetUI
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func setUI() {
        nameLabel.underline()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        
        contentTextView.dropShadow(color: UIColor.systemGray3, opacity: 0.3, offSet: .zero, radius: 10, scale: true)
        contentTextView.delegate = self
        contentTextView.layer.cornerRadius = 10
        
        selectImageButton.layer.cornerRadius = 15
        selectImageButton.layer.masksToBounds = true
        
        placeTextField.placeholder = "Location"
        
        self.hideKeyboardWhenTappedAround()

        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .clear
    }
    
//MARK: SetData
    func setDataUser() {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: DataManager.shared.user.nameImage!) { result in
            DispatchQueue.main.async() {
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: result)
            }
        }
        nameLabel.text = DataManager.shared.user.name
    }
    
    func getCurrentDate() -> String {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        let result = String(dateTimeComponents.day!) + "-" + String(dateTimeComponents.month!) + "-" + String(dateTimeComponents.year!)
        return result
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: (collectionView.bounds.width - 20)*2/3, height: collectionView.bounds.height - 20), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//MARK: IBAction
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        imagePicker.selectionImageTintColor = UIColor.black
        imagePicker.selectionImage = UIImage(systemName: "checkmark")
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        imagePicker.maximumSelectionsAllowed = 10
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("You cannot select that many images!", comment: "")
        imagePicker.configuration = configuration
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        var resultImage = [String]()
        for asset in resultImagePicker {
            let assetResources = PHAssetResource.assetResources(for: asset)
            let nameImage = assetResources.first!.originalFilename
            resultImage.append(nameImage)
            DataImageManager.shared.uploadsImage(image: Utilities.getAssetThumbnail(asset: asset), place: "post", nameImage: nameImage) { result in
            }
        }
        if contentTextView.text != "" && resultImage.count != 0 && placeTextField.text != "" {
            SVProgressHUD.show()
            dataPost.idUser = DataManager.shared.user.id!
            dataPost.date = getCurrentDate()
            dataPost.listImage = resultImage
            dataPost.content = contentTextView.text
            dataPost.place = placeTextField.text
            DataManager.shared.getCountObject(nameCollection: "posts") { result in
                self.dataPost.id = String(result + 1)
                DataManager.shared.setDataPost(data: self.dataPost) { result in
                    SVProgressHUD.dismiss()
                    self.placeTextField.text = ""
                    self.contentTextView.text = ""
                    self.resultImagePicker = [PHAsset]()
                    self.showAlert(message: result)
                }
            }
        } else {
            showAlert(message: "please fill in all fields and select image")
        }
    }

}

extension CreatePostViewController: UITextViewDelegate {
}

//MARK: OpalImagePickerControllerDelegate
extension CreatePostViewController: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        resultImagePicker = assets
        self.collectionView.reloadData()
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UICollectionViewDelegate
extension CreatePostViewController: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource
extension CreatePostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultImagePicker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return ImageCollectionViewCell()
        }
        cell.imageView.image = self.getAssetThumbnail(asset: self.resultImagePicker[indexPath.row])
        return cell
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension CreatePostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (collectionView.bounds.width - 20)*3/2, height: collectionView.bounds.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
