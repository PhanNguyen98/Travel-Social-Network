//
//  EditProfileViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/01/2021.
//

import UIKit
import OpalImagePicker
import Photos

protocol EditProfileViewControllerDelegate: class {
    func changeAvatarImage(image: UIImage?)
    func changeBackgroundImage(image: UIImage?)
}

class EditProfileViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    weak var editVCDelegate: EditProfileViewControllerDelegate?
    var imagePicker: ImagePicker!
    var fileNameAvatar: String?
    var fileNameBackground: String?
    var backgroundImage = PHAsset()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUI()
        setViewKeyboard()
        Utilities.checkPhotoLibrary()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

//MARK: IBAction
    @IBAction func changeAvatarProfile(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func changeBackground(_ sender: Any) {
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
        imagePicker.selectionImageTintColor = UIColor.black
        imagePicker.selectionImage = UIImage(systemName: "checkmark")
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("You cannot select that many images!", comment: "")
        imagePicker.configuration = configuration
        present(imagePicker, animated: true, completion: nil)
    }
    
//MARK: SetUI
    func setData() {
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: DataManager.shared.user.nameImage!) { result in
            self.avatarImageView.image = result
        }
        DataImageManager.shared.downloadImage(path: "avatar", nameImage: DataManager.shared.user.nameBackgroundImage!) { result in
            self.backgroundImageView.image = result
        }
        self.nameTextField.text = DataManager.shared.user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        guard let birthdate = DataManager.shared.user.birthday else { return }
        let date = dateFormatter.date(from: birthdate)
        self.birthdayDatePicker.date = date ?? Date()
        self.placeTextField.text = DataManager.shared.user.place
    }
    
    func setViewKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        nameTextField.layer.cornerRadius = 5
        placeTextField.layer.cornerRadius = 5
        birthdayDatePicker.preferredDatePickerStyle = .compact
        self.hideKeyboardWhenTappedAround()
    }
    
    func setNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveProfile))
    }
    
//MARK: @objc func
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -keyboardHeight
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveProfile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        DataManager.shared.user.birthday = formatter.string(from: birthdayDatePicker.date)
        DataManager.shared.user.name = nameTextField.text
        if let nameImage = fileNameAvatar {
            DataManager.shared.user.nameImage = nameImage
        }
        if let nameImage = fileNameBackground {
            DataManager.shared.user.nameBackgroundImage = nameImage
        }
        DataManager.shared.user.place = placeTextField.text
        DataImageManager.shared.uploadsImage(image: backgroundImageView.image!, place: "avatar", nameImage: fileNameBackground ?? "")
        DataImageManager.shared.uploadsImage(image: avatarImageView.image!, place: "avatar", nameImage: fileNameAvatar ?? "")
        DataManager.shared.setDataUser()
        DataManager.shared.getUserFromId(id: DataManager.shared.user.id!)
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: OpalImagePickerControllerDelegate
extension EditProfileViewController: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        backgroundImageView.image = Utilities.getAssetThumbnail(asset: assets[0])
        self.editVCDelegate?.changeBackgroundImage(image: Utilities.getAssetThumbnail(asset: assets[0]))
        let assetResources = PHAssetResource.assetResources(for: assets[0])
        fileNameBackground = assetResources.first!.originalFilename
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: ImagePickerDelegate
extension EditProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let avatarImage = image {
            self.avatarImageView.image = avatarImage
            self.editVCDelegate?.changeAvatarImage(image: avatarImage)
        }
    }
    
    func getFileName(fileName: String?) {
        self.fileNameAvatar = fileName
    }
    
}
