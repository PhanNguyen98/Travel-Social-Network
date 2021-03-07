//
//  DataManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/01/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class DataManager {
    static let shared = DataManager()
    let db = Firestore.firestore()
    var user = User(id: "", nameImage: "user.png", name: nil, birthday: nil, place: nil, listIdFriends: nil, nameBackgroundImage: "background.jpg")
    
    private init(){
    }
    
    func setDataUser() {
        db.collection("users").document(user.id!).setData([
            "id": user.id ?? "",
            "avatar": user.nameImage ?? "user.png",
            "name": user.name ?? "",
            "birthday": user.birthday ?? "",
            "place": user.place ?? "",
            "listIdFriends": user.listIdFriends ?? [],
            "background": user.nameBackgroundImage ?? "background.jpg"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataFriend(id: String, listFriend: [String]) {
        db.collection("users").document(id).setData([
            "listIdFriends": listFriend
        ], merge: true)
    }
    
    func setDataPost(data: Post) {
        db.collection("posts").document(data.id!).setData([
            "id": data.id!,
            "idUser": data.idUser ?? "",
            "listImage": data.listImage ?? [""],
            "content": data.content ?? "",
            "date": data.date ?? "",
            "listIdHeart": data.listIdHeart ?? []
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataNotify(data: Notify) {
        db.collection("notifies").document().setData([
            "id": data.id,
            "nameUser": data.nameUser,
            "content": data.content,
            "nameImageAvatar": data.nameImageAvatar
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataComment(data: Comment) {
        db.collection("comments").document().setData([
            "idPost": data.idPost ?? "",
            "idUser": data.idUser ?? "",
            "content": data.content ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataListIdHeart(id: String, listIdHeart: [String]) {
        db.collection("posts").document(id).setData([
            "listIdHeart": listIdHeart
        ], merge: true)
    }
    
    
    func getUserFromId(id: String) {
        db.collection("users").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        for (key, values) in document.data() {
                            switch key {
                            case "birthday":
                                self.user.birthday = values as? String
                            case "place":
                                self.user.place = values as? String
                            case "id":
                                self.user.id = values as? String
                            case "listIdFriends":
                                self.user.listIdFriends = values as? [String]
                            case "name":
                                self.user.name = values as? String
                            case "avatar":
                                self.user.nameImage = values as? String
                            case "background":
                            self.user.nameBackgroundImage = values as? String
                            default:
                                break
                            }
                        }
                    }
                }
        }
    }
    
    func getComment(idPost: String, completionHandler: @escaping (_ result: [Comment]) -> ()) {
        var result = [Comment]()
        db.collection("comments").whereField("idPost", isEqualTo: idPost).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print ("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let comment = Comment()
                    for (key, values) in document.data() {
                        switch key {
                        case "idPost":
                            comment.idPost = values as? String
                        case "idUser":
                            comment.idUser = values as? String
                        case "content":
                            comment.content = values as? String
                        default:
                            break
                        }
                    }
                    result.append(comment)
                }
                completionHandler(result)
            }
        }
    }
    
    func getUserFromId(id: String, completionHandler: @escaping (_ result: User) -> ()) {
        var result = User()
        db.collection("users").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        for (key, values) in document.data() {
                            switch key {
                            case "birthday":
                                result.birthday = values as? String
                            case "place":
                                result.place = values as? String
                            case "id":
                                result.id = values as? String
                            case "listIdFriends":
                                result.listIdFriends = values as? [String]
                            case "name":
                                result.name = values as? String
                            case "avatar":
                                result.nameImage = values as? String
                            case "background":
                                result.nameBackgroundImage = values as? String
                            default:
                                break
                            }
                        }
                    }
                    completionHandler(result)
                }
        }
    }
    
    func getUserFromName(name: String,completionHandler: @escaping (_ result: [User]) -> ()) {
        var dataSources = [User]()
        db.collection("users").whereField("name", isEqualTo: name)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var result = User()
                        for (key, values) in document.data() {
                            switch key {
                            case "birthday":
                                result.birthday = values as? String
                            case "place":
                                result.place = values as? String
                            case "id":
                                result.id = values as? String
                            case "listIdFriends":
                                result.listIdFriends = values as? [String]
                            case "name":
                                result.name = values as? String
                            case "avatar":
                                result.nameImage = values as? String
                            case "background":
                                result.nameBackgroundImage = values as? String
                            default:
                                break
                            }
                        }
                        dataSources.append(result)
                    }
                    completionHandler(dataSources)
                }
        }
    }
    
    func getPostFromId(idUser: String, completionHandler: @escaping (_ result: [Post]) -> ()) {
        var dataSources = [Post]()
        db.collection("posts").whereField("idUser", isEqualTo: idUser)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = Post()
                        for (key, values) in document.data() {
                            switch key {
                            case "id":
                                data.id = values as? String
                            case "idUser":
                                data.idUser = values as? String
                            case "listImage":
                                data.listImage = values as? [String]
                            case "content":
                                data.content = values as? String
                            case "date":
                                data.date = values as? String
                            case "listIdHeart":
                                data.listIdHeart = values as? [String]
                            default:
                                break
                            }
                        }
                        dataSources.append(data)
                    }
                    completionHandler(dataSources)
                }
        }
    }
    
    func getCountPost(completionHandler: @escaping (_ result: Int) -> ()) {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)");
            }
            else {
                completionHandler(querySnapshot?.documents.count ?? 0)
            }
        }
    }
    
    func getCountComment(idPost: String, completionHandler: @escaping (_ result: Int) -> ()) {
        db.collection("comments").whereField("idPost", isEqualTo: idPost).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                completionHandler(querySnapshot?.documents.count ?? 0)
            }
        }
    }
    
    func getListUser(listId: [String], completionHandler: @escaping (_ result: [User]) -> ()) {
        var result = [User]()
        db.collection("users").whereField("id", in: listId).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var user = User()
                        for (key, values) in document.data() {
                            switch key {
                            case "birthday":
                                user.birthday = values as? String
                            case "place":
                                user.place = values as? String
                            case "id":
                                user.id = values as? String
                            case "listIdFriends":
                                user.listIdFriends = values as? [String]
                            case "name":
                                user.name = values as? String
                            case "avatar":
                                user.nameImage = values as? String
                            case "background":
                                user.nameBackgroundImage = values as? String
                            default:
                                break
                            }
                        }
                        result.append(user)
                    }
                    completionHandler(result)
                }
        }
    }
    
    func getPostFromListId(listId: [String], completionHandler: @escaping (_ result: [Post]) -> ()) {
        var result = [Post]()
        db.collection("posts").whereField("idUser", in: listId).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let post = Post()
                        for (key, values) in document.data() {
                            switch key {
                            case "id":
                                post.id = values as? String
                            case "idUser":
                                post.idUser = values as? String
                            case "listImage":
                                post.listImage = values as? [String]
                            case "content":
                                post.content = values as? String
                            case "date":
                                post.date = values as? String
                            case "listIdHeart":
                                post.listIdHeart = values as? [String]
                            default:
                                break
                            }
                        }
                        result.append(post)
                    }
                    completionHandler(result)
                }
        }
    }
    
    func getUserFromListId(listId: [String], completionHandler: @escaping (_ result: [User]) -> ()) {
        var result = [User]()
        db.collection("users").whereField("id", in: listId).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print(document)
                        var user = User()
                        for (key, values) in document.data() {
                            switch key {
                            case "birthday":
                                user.birthday = values as? String
                            case "place":
                                user.place = values as? String
                            case "id":
                                user.id = values as? String
                            case "listIdFriends":
                                user.listIdFriends = values as? [String]
                            case "name":
                                user.name = values as? String
                            case "avatar":
                                user.nameImage = values as? String
                            case "background":
                                user.nameBackgroundImage = values as? String
                            default:
                                break
                            }
                        }
                        result.append(user)
                    }
                    completionHandler(result)
                }
        }
    }
    
}
