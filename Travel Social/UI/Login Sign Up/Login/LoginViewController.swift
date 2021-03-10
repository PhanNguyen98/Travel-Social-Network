//
//  LoginViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 20/01/2021.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
//MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setViewKeyboard()
        setNavigation()
        emailTextField.text = "c@c.com"
        passwordTextField.text = "C123456"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//MARK: SetUI
    func setNavigation() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setUI() {
        self.view.setBackgroundImage(img: UIImage(named: "background")!)
        self.hideKeyboardWhenTappedAround()
        
        emailTextField.layer.cornerRadius = 20
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        
        logInButton.layer.cornerRadius = logInButton.frame.height / 2
        logInButton.layer.masksToBounds = true
        
        signUpButton.layer.cornerRadius = logInButton.frame.height / 2
        signUpButton.layer.masksToBounds = true
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//MARK: SetKeyboard
    func setViewKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentViewBottomConstraint.constant = keyboardSize.height - 50
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        contentViewBottomConstraint.constant = 0
    }
    
//MARK: IBAction
    @IBAction func logIn(_ sender: Any) {
        self.logInButton.isEnabled = false
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.logInButton.isEnabled = true
            return
        }
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.logInButton.isEnabled = true
                self.showError(message: error!.localizedDescription)
            } else {
                self.logInButton.isEnabled = true
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                DataManager.shared.getUserFromId(id: (result!.user.uid)) {
                    SVProgressHUD.dismiss()
                    let customBarViewController = CustomBarViewController()
                    self.navigationController?.pushViewController(customBarViewController, animated: false)
                }
            }
        }
    }
    
    @IBAction func showSignUp(_ sender: Any) {
        emailTextField.text = ""
        passwordTextField.text = ""
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .overFullScreen
        signUpViewController.signUpDelegate = self
        self.present(signUpViewController, animated: true, completion: nil)
    }

}

extension LoginViewController: SignUpViewControllerDelegate {
    func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
