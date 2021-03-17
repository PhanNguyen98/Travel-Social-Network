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
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
//MARK: SetUI
    func setTabBar() {
        self.delegate = self
        homeViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        createPostViewController.tabBarItem.image = UIImage(systemName: "text.badge.plus")
        profileUserViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        notifyViewController.tabBarItem.image = UIImage(systemName: "bell.fill")
        weatherViewController.tabBarItem.image = UIImage(systemName: "cloud.sun.rain.fill")
        viewControllers = [homeViewController, weatherViewController, createPostViewController, notifyViewController, profileUserViewController]
        tabBar.tintColor = UIColor(red: 0/255.0, green: 194/255, blue: 166/255, alpha: 1)
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
        }   
    }
    
    func setNavigation() {
        let optionButton = UIBarButtonItem(image: UIImage(named: "option"), style: .plain, target: self, action: #selector(showOption))
        self.navigationItem.leftBarButtonItem = optionButton
    }
    
    @objc func showOption() {
        self.navigationController?.present(setting(), animated: true, completion: nil)
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

}

extension CustomBarViewController: UITabBarControllerDelegate {
}
