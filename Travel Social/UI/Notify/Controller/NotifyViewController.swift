//
//  NotifyViewController.swift
//  Travel Social
//
//  Created by Phan Nguyen on 02/03/2021.
//

import UIKit
import FirebaseFirestore

class NotifyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSources = [Notify]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NotifyTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifyTableViewCell")
    }
    
    func setData() {
        self.dataSources = DatabaseManager.shared.dataNotify
        self.tableView.reloadData()
    }
    
}

extension NotifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSources[indexPath.row].type == "follow" {
            DataManager.shared.getUserFromId(id: dataSources[dataSources.count - indexPath.row - 1].idFriend) { result in
                let friendViewController = FriendViewController()
                friendViewController.dataUser = result
                DataManager.shared.getPostFromId(idUser: result.id ?? "") { result in
                    friendViewController.dataPost = result
                    self.navigationController?.pushViewController(friendViewController, animated: true)
                }
            }
        } else {
            DataManager.shared.getPostFromId(idPost: dataSources[dataSources.count - indexPath.row - 1].idPost) { result in
                let commentViewController = CommentViewController()
                commentViewController.dataPost = result[0]
                self.navigationController?.pushViewController(commentViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "  Notifications"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        headerView.addSubview(label)
        
        return headerView
    }
    
}

extension NotifyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyTableViewCell", for: indexPath) as? NotifyTableViewCell else {
            return NotifyTableViewCell()
        }
        cell.selectionStyle = .none
        cell.setData(data: dataSources[dataSources.count - indexPath.row - 1])
        return cell
    }

}
