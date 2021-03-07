//
//  KeySearchViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 01/02/2021.
//

import UIKit

class KeySearchViewController: UIViewController {

//MARK: Propreties
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var dataSources = [User]()
    var keySearch = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        setTableView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchUser()
    }
    
    func setSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.text = keySearch
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func searchUser() {
        DataManager.shared.getUserFromName(name: searchController.searchBar.text ?? "") { result in
            var listUser = result
            for index in 0..<result.count {
                if result[index].id == DataManager.shared.user.id {
                    listUser.remove(at: index)
                    self.dataSources = listUser
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }

}

extension KeySearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSources[indexPath.row].id == DataManager.shared.user.id {
            let userViewController = UserViewController()
            navigationController?.pushViewController(userViewController, animated: true)
        } else {
            self.tableView.allowsSelection = false
            let friendViewController = FriendViewController()
            DataManager.shared.getPostFromId(idUser: dataSources[indexPath.row].id!) { result in
                self.tableView.allowsSelection = true
                friendViewController.dataUser = self.dataSources[indexPath.row]
                friendViewController.dataPost = result
                self.navigationController?.pushViewController(friendViewController, animated: true)
            }
        }
    }
}

extension KeySearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UserTableViewCell() }
        cell.selectionStyle = .none
        cell.setData(item: dataSources[indexPath.row])
        return cell
    }
    
}

extension KeySearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let keySearch = searchBar.text {
            UserDefaultManager.shared.setData(text: keySearch)
            DataManager.shared.getUserFromName(name: keySearch) { result in
                var listUser = result
                for index in 0..<result.count {
                    if result[index].id == DataManager.shared.user.id {
                        listUser.remove(at: index)
                        self.dataSources = listUser
                        self.tableView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: nil)
    }
}
