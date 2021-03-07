//
//  SearchViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/01/2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        dataSources = UserDefaultManager.shared.getData()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "KeySearchTableViewCell", bundle: nil), forCellReuseIdentifier: "KeySearchTableViewCell")
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
}

extension SearchViewController: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = cell as? SearchTableViewCell else { return }
            cell.setSearchDelegate(delegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keySearchViewController = KeySearchViewController()
        keySearchViewController.keySearch = dataSources[indexPath.row]
        let navigationController = UINavigationController(rootViewController: keySearchViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 45
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return dataSources.count
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                UserDefaultManager.shared.deleteItem(key: dataSources[indexPath.row])
                dataSources.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .middle)
                self.tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return SearchTableViewCell() }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeySearchTableViewCell", for: indexPath) as? KeySearchTableViewCell else { return KeySearchTableViewCell() }
            cell.keySearchLabel.text = dataSources[indexPath.row]
            return cell
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let keySearchViewController = KeySearchViewController()
        let navigationController = UINavigationController(rootViewController: keySearchViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
        searchBar.endEditing(true)
    }
}

