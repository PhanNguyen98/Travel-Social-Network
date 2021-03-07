//
//  ListUserViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/02/2021.
//

import UIKit

class ListUserViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [User]()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//MARK: SetTableView
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }

}

//MARK: UITableViewDelegate
extension ListUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: UITableViewDataSource
extension ListUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UserTableViewCell()
        }
        cell.setData(item: dataSources[indexPath.row])
        return cell
    }
    
}
