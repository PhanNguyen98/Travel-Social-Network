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
    let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
    let weatherNavigationController = UINavigationController(rootViewController: WeatherViewController())
    let createPostNavigationController = UINavigationController(rootViewController: CreatePostViewController())
    let notifyNavigationController = UINavigationController(rootViewController: NotifyViewController())
    let profileUserNavigationController = UINavigationController(rootViewController: ProfileUserViewController())
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
//MARK: SetUI
    func setTabBar() {
        homeNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house.fill"), tag: 0)
        createPostNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.square.fill"), tag: 2)
        weatherNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cloud.sun.rain.fill"), tag: 1)
        notifyNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bell.fill"), tag: 3)
        profileUserNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.fill"), tag: 4)
        self.viewControllers = [homeNavigationController, weatherNavigationController, createPostNavigationController, notifyNavigationController, profileUserNavigationController]
        self.tabBar.tintColor = UIColor(red: 0/255.0, green: 194/255, blue: 166/255, alpha: 1)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNotify(_:)), name: NSNotification.Name("Notify"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDefaultNotify(_:)), name: NSNotification.Name("defaultNotify"), object: nil)
    }

    @objc func showNotify(_ notification: Notification) {
        notifyNavigationController.tabBarItem.image = UIImage(systemName: "bell.badge.fill")
    }
    
    @objc func setDefaultNotify(_ notification: Notification) {
        notifyNavigationController.tabBarItem.image = UIImage(systemName: "bell.fill")
    }
    
}
