//
//  DataNotifyManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 22/03/2021.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    var dataNotify = [Notify]()
    
    private init() {
    }
    
    func handleNotifyChanges(completed: @escaping () -> ()) {
        db.collection("notifies").whereField("id", isEqualTo: DataManager.shared.user.id!).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return completed()
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let newNotify = Notify()
                    newNotify.setData(withData: diff.document)
                    self.dataNotify.append(newNotify)
                    if self.dataNotify.count > UserDefaultManager.shared.getDataNotify(keyData: DataManager.shared.user.id ?? "") {
                        NotificationCenter.default.post(name: NSNotification.Name("Notify"), object: nil)
                        UserDefaultManager.shared.setDataNotify(data: DatabaseManager.shared.dataNotify.count, keyData: DataManager.shared.user.id ?? "")
                    }
                }
                if (diff.type == .modified) {
                    let docId = diff.document.documentID
                    if let indexOfNotifyToModify = self.dataNotify.firstIndex(where: { $0.idNotify == docId} ) {
                        let notifyToModify = self.dataNotify[indexOfNotifyToModify]
                        notifyToModify.updateNotify(withData: diff.document)
                    }
                }
                if (diff.type == .removed) {
                    let docId = diff.document.documentID
                    if let indexOfNotifyToRemove = self.dataNotify.firstIndex(where: { $0.idNotify == docId} ) {
                        self.dataNotify.remove(at: indexOfNotifyToRemove)
                    }
                }
            }
            completed()
        }
    }
}
