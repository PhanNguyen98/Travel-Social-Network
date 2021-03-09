//
//  DetailImageViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 01/02/2021.
//

import UIKit

class DetailImageViewController: UIViewController {

//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [String]()
    
//MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
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
    
//MARK: SetData
    func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailImageTableViewCell")
    }
    
    func setNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
//MARK: @objc func
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: UITableViewDelegate
extension DetailImageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 10
        }
    }

}

//MARK: UITableViewDataSource
extension DetailImageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageTableViewCell", for: indexPath) as? DetailImageTableViewCell else {
            return DetailImageTableViewCell()
        }
        cell.loadData(nameImage: dataSources[indexPath.section])
        return cell
    }

}
