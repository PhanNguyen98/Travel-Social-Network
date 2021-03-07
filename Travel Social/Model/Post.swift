//
//  Post.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/01/2021.
//

import UIKit
import FirebaseFirestore

class Post {
    var id: String?
    var idUser: String?
    var content: String?
    var listImage: [String]?
    var date: String?
    var listIdHeart: [String]?
    
    func updatePost(withData: QueryDocumentSnapshot) {
        self.idUser = withData.get("idUser") as? String ?? ""
        self.content = withData.get("content") as? String ?? ""
        self.listImage = withData.get("listImage") as? [String] ?? []
        self.date = withData.get("date") as? String ?? ""
        self.listIdHeart = withData.get("listIdHeart") as? [String] ?? []
    }
}
