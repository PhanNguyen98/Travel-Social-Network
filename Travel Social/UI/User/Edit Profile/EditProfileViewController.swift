//
//  EditProfileViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/01/2021.
//

import UIKit
import Photos
import Kingfisher
import SVProgressHUD

protocol EditProfileViewControllerDelegate: class {
    func changeAvatarImage(image: UIImage?)
}

class EditProfileViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var jobTextField: UITextField!
    
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
    
//MARK: SetUI
    func setData() {
        DispatchQueue.main.async {
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: URL(string: DataManager.shared.user.nameImage!))
        }
        self.nameTextField.text = DataManager.shared.user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        guard let birthdate = DataManager.shared.user.birthday else { return }
        let date = dateFormatter.date(from: birthdate)
        self.birthdayDatePicker.date = date ?? Date()
        self.placeTextField.text = DataManager.shared.user.place
        self.jobTextField.text = DataManager.shared.user.job
    }
    
    func setViewKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func setUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2 - 8
        avatarImageView.layer.borderColor = UIColor.systemGray3.cgColor
        avatarImageView.layer.borderWidth = 1
        
        nameTextField.layer.cornerRadius = 10
        placeTextField.layer.cornerRadius = 10
        jobTextField.layer.cornerRadius = 10
        birthdayDatePicker.preferredDatePickerStyle = .compact
        birthdayDatePicker.maximumDate = Date()
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
        let info = sender.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;

        let activeField: UITextField? = [nameTextField, placeTextField, jobTextField].first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
        
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveProfile() {
        SVProgressHUD.show()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        DataManager.shared.user.birthday = formatter.string(from: birthdayDatePicker.date)
        DataManager.shared.user.name = nameTextField.text
        DataManager.shared.user.job = jobTextField.text
        DataManager.shared.user.place = placeTextField.text
        DataImageManager.shared.uploadsImage(image: avatarImageView.image!, place: "avatar", nameImage: fileNameAvatar ?? "") { result in
            switch result {
            case .success(let url):
                SVProgressHUD.dismiss()
                DataManager.shared.user.nameImage = url
                DataManager.shared.setDataUser()
                DataManager.shared.getUserFromId(id: DataManager.shared.user.id!) {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                self.present(Utilities.showAlert(message: error.localizedDescription), animated: true, completion: nil)
            }
        }
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
