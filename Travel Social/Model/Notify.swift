//
//  Notify.swift
//  Travel Social
//
//  Created by Phan Nguyen on 02/03/2021.
//

import Foundation
import FirebaseFirestore

class Notify {
    var idNotify = ""
    var id = ""
    var content = ""
    var idFriend = ""
    var type = ""
    var idType = ""
    
    func setData(withData: QueryDocumentSnapshot) {
        self.idNotify = withData.documentID
        self.content = withData.get("content") as? String ?? ""
        self.id = withData.get("id") as? String ?? ""
        self.idFriend = withData.get("idFriend") as? String ?? ""
        self.type = withData.get("type") as? String ?? ""
        self.idType = withData.get("idType") as? String ?? ""
    }
    
    func updateNotify(withData: QueryDocumentSnapshot) {
        self.content = withData.get("content") as? String ?? ""
        self.id = withData.get("id") as? String ?? ""
        self.idFriend = withData.get("idFriend") as? String ?? ""
        self.type = withData.get("type") as? String ?? ""
        self.idType = withData.get("idType") as? String ?? ""
    }
}
