//
//  CustomBarViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit
import Photos

class CustomBarViewController: UITabBarController {

//MARK: Properties
    var homeViewController = HomeViewController()
    var profileUserViewController = ProfileUserViewController()
    var weatherViewController = WeatherViewController()
    var notifyViewController = NotifyViewController()
    var createPostViewController = CreatePostViewController()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setNotification()
        setNavigationBar()
    }
    
//MARK: SetUI
    func setTabBar() {
        self.delegate = self
        homeViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        createPostViewController.tabBarItem.image = UIImage(systemName: "plus.rectangle")
        profileUserViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        notifyViewController.tabBarItem.image = UIImage(systemName: "bell.fill")
        weatherViewController.tabBarItem.image = UIImage(systemName: "cloud.sun.rain.fill")
        viewControllers = [homeViewController, weatherViewController, createPostViewController, notifyViewController, profileUserViewController]
        tabBar.tintColor = UIColor(red: 0/255.0, green: 194/255, blue: 166/255, alpha: 1)
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
        }   
    }
    
    func setNavigationBar(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"option"), for: .normal)
        menuBtn.imageView?.contentMode = .scaleAspectFill
        menuBtn.addTarget(self, action: #selector(showOption), for: UIControl.Event.touchUpInside)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBtn)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func setting() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { _ in
            self.navigationController?.popViewController(animated: false)
        }
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.pruneNegativeWidthConstraints()
        return alertController
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getData(_:)), name: NSNotification.Name("Notify"), object: nil)
    }
    
    @objc func showOption() {
        self.navigationController?.present(setting(), animated: true, completion: nil)
    }

    @objc func getData(_ notification: Notification) {
        notifyViewController.tabBarItem.image = notification.object as? UIImage
    }
}

extension CustomBarViewController: UITabBarControllerDelegate {
}
