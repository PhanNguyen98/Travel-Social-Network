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
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NotifyTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifyTableViewCell")
    }
    
    func setData() {
        handleNotifyChanges() {
            self.tableView.reloadData()
        }
    }
    
    func handleNotifyChanges(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("notifies").whereField("id", isEqualTo: DataManager.shared.user.id!).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return completed()
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let newNotify = Notify()
                    newNotify.setData(withData: diff.document)
                    self.dataSources.append(newNotify)
                }
                if (diff.type == .modified) {
                    let docId = diff.document.documentID
                    if let indexOfNotifyToModify = self.dataSources.firstIndex(where: { $0.idNotify == docId} ) {
                        let notifyToModify = self.dataSources[indexOfNotifyToModify]
                        notifyToModify.updateNotify(withData: diff.document)
                    }
                }
                if (diff.type == .removed) {
                    let docId = diff.document.documentID
                    if let indexOfNotifyToRemove = self.dataSources.firstIndex(where: { $0.idNotify == docId} ) {
                        self.dataSources.remove(at: indexOfNotifyToRemove)
                    }
                }
            }
            completed()
        }
    } 

}

extension NotifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
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
        cell.setData(data: dataSources[indexPath.row])
        return cell
    }

}
