//
//  Comment.swift
//  Travel Social
//
//  Created by Phan Nguyen on 25/02/2021.
//

import Foundation
import FirebaseFirestore

class Comment {
    var idComment: String?
    var idPost: String?
    var idUser: String?
    var content: String?
    
    func setData(withData: QueryDocumentSnapshot) {
        self.idComment = withData.documentID
        self.idPost = withData.get("idPost") as? String ?? ""
        self.idUser = withData.get("idUser") as? String ?? ""
        self.content = withData.get("content") as? String ?? ""
    }
    
    func updateComment(withData: QueryDocumentSnapshot) {
        self.idPost = withData.get("idPost") as? String ?? ""
        self.idUser = withData.get("idUser") as? String ?? ""
        self.content = withData.get("content") as? String ?? ""
    }
}
