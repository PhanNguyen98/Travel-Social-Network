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
    var nameUser = ""
    var nameImageAvatar = ""
    
    func setData(withData: QueryDocumentSnapshot) {
        self.idNotify = withData.documentID
        self.content = withData.get("content") as? String ?? ""
        self.id = withData.get("id") as? String ?? ""
        self.nameUser = withData.get("nameUser") as? String ?? ""
        self.nameImageAvatar = withData.get("nameImageAvatar") as? String ?? ""
    }
    
    func updateNotify(withData: QueryDocumentSnapshot) {
        self.content = withData.get("content") as? String ?? ""
        self.id = withData.get("id") as? String ?? ""
        self.nameUser = withData.get("nameUser") as? String ?? ""
        self.nameImageAvatar = withData.get("nameImageAvatar") as? String ?? ""
    }
}
