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
    var searchViewController = SearchViewController()
    var notifyViewController = NotifyViewController()
    var userViewController = UserViewController()
    var weatherViewController = WeatherViewController()
    
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
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
        notifyViewController.tabBarItem.image = UIImage(systemName: "bell.fill")
        userViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        weatherViewController.tabBarItem.image = UIImage(systemName: "cloud.sun.rain.fill")
        viewControllers = [homeViewController, searchViewController, weatherViewController, notifyViewController, userViewController]
        tabBar.tintColor = UIColor.blue
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
        }   
    }
    
}

extension CustomBarViewController: UITabBarControllerDelegate {
}
