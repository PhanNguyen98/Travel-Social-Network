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
    var createPostViewController = CreatePostViewController()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
//MARK: SetTabbar
    func setTabBar() {
        self.delegate = self
        homeViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        createPostViewController.tabBarItem.image = UIImage(systemName: "")
        profileUserViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        weatherViewController.tabBarItem.image = UIImage(systemName: "cloud.sun.rain.fill")
        viewControllers = [homeViewController, weatherViewController, profileUserViewController]
        tabBar.tintColor = UIColor(red: 0/255.0, green: 194/255, blue: 166/255, alpha: 1)
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
        }   
    }

}

extension CustomBarViewController: UITabBarControllerDelegate {
}
