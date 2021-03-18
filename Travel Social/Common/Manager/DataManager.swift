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
    private let db = Firestore.firestore()
    var user = User(id: "", nameImage: AccessKey.urlAvatar, name: nil, birthday: nil, place: nil, listIdFollowers: nil, listIdFollowing: nil, job: nil)
    
    private init(){
    }
    
    func setDataUser() {
        db.collection("users").document(user.id!).setData([
            "id": user.id ?? "",
            "avatar": user.nameImage ?? AccessKey.urlAvatar,
            "name": user.name ?? "",
            "birthday": user.birthday ?? "",
            "place": user.place ?? "",
            "listIdFollowers": user.listIdFollowers ?? [],
            "listIdFollowing": user.listIdFollowing ?? [],
            "job": user.job ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataFollowers(id: String, listIdFollowers: [String]) {
        db.collection("users").document(id).setData([
            "listIdFollowers": listIdFollowers
        ], merge: true)
    }
    
    func setDataFollowing(id: String, listIdFollowing: [String]) {
        db.collection("users").document(id).setData([
            "listIdFollowing": listIdFollowing
        ], merge: true)
    }
    
    func setDataPost(data: Post, completionHandler: @escaping (_ result: Result<String, Error>) -> ()) {
        db.collection("posts").document(data.id!).setData([
            "id": data.id!,
            "idUser": data.idUser ?? "",
            "listImage": data.listImage ?? [""],
            "content": data.content ?? "",
            "date": data.date ?? "",
            "listIdHeart": data.listIdHeart ?? [],
            "place": data.place ?? ""
        ]) { err in
            if let err = err {
                completionHandler(.failure(err))
            } else {
                completionHandler(.success("Create Post Success"))
            }
        }
    }
    
    func setDataNotifyComment(data: Notify) {
        db.collection("notifies").document().setData([
            "id": data.id,
            "idFriend": data.idFriend,
            "content": data.content,
            "type": data.type,
            "idPost": data.idPost
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataNotify(data: Notify, idDocument: String) {
        db.collection("notifies").document(idDocument).setData([
            "id": data.id,
            "idFriend": data.idFriend,
            "content": data.content,
            "type": data.type,
            "idPost": data.idPost
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setDataComment(data: Comment, id: Int) {
        db.collection("comments").document(String(id)).setData([
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
    
    
    func getUserFromId(id: String, complete:@escaping () -> Void) {
        db.collection("users").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        for (key, value) in document.data() {
                            switch key {
                            case "birthday":
                                self.user.birthday = value as? String
                            case "place":
                                self.user.place = value as? String
                            case "id":
                                self.user.id = value as? String
                            case "listIdFollowers":
                                self.user.listIdFollowers = value as? [String]
                            case "listIdFollowing":
                                self.user.listIdFollowing = value as? [String]
                            case "name":
                                self.user.name = value as? String
                            case "avatar":
                                self.user.nameImage = value as? String
                            case "job":
                                self.user.job = value as? String
                            default:
                                break
                            }
                        }
                    }
                    complete()
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
                    for (key, value) in document.data() {
                        switch key {
                        case "idPost":
                            comment.idPost = value as? String
                        case "idUser":
                            comment.idUser = value as? String
                        case "content":
                            comment.content = value as? String
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
                        for (key, value) in document.data() {
                            switch key {
                            case "birthday":
                                result.birthday = value as? String
                            case "place":
                                result.place = value as? String
                            case "id":
                                result.id = value as? String
                            case "listIdFollowers":
                                result.listIdFollowers = value as? [String]
                            case "listIdFollowing":
                                result.listIdFollowing = value as? [String]
                            case "name":
                                result.name = value as? String
                            case "avatar":
                                result.nameImage = value as? String
                            case "job":
                                result.job = value as? String
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
                        for (key, value) in document.data() {
                            switch key {
                            case "birthday":
                                result.birthday = value as? String
                            case "place":
                                result.place = value as? String
                            case "id":
                                result.id = value as? String
                            case "listIdFollowers":
                                result.listIdFollowers = value as? [String]
                            case "listIdFollowing":
                                result.listIdFollowing = value as? [String]
                            case "name":
                                result.name = value as? String
                            case "avatar":
                                result.nameImage = value as? String
                            case "job":
                                result.job = value as? String
                            default:
                                break
                            }
                        }
                        if result.id != self.user.id {
                            dataSources.append(result)
                        }
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
                        for (key, value) in document.data() {
                            switch key {
                            case "id":
                                data.id = value as? String
                            case "idUser":
                                data.idUser = value as? String
                            case "listImage":
                                data.listImage = value as? [String]
                            case "content":
                                data.content = value as? String
                            case "date":
                                data.date = value as? String
                            case "listIdHeart":
                                data.listIdHeart = value as? [String]
                            case "place":
                                data.place = value as? String
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
    
    func getPostFromId(idPost: String, completionHandler: @escaping (_ result: [Post]) -> ()) {
        var dataSources = [Post]()
        db.collection("posts").whereField("id", isEqualTo: idPost)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = Post()
                        for (key, value) in document.data() {
                            switch key {
                            case "id":
                                data.id = value as? String
                            case "idUser":
                                data.idUser = value as? String
                            case "listImage":
                                data.listImage = value as? [String]
                            case "content":
                                data.content = value as? String
                            case "date":
                                data.date = value as? String
                            case "listIdHeart":
                                data.listIdHeart = value as? [String]
                            case "place":
                                data.place = value as? String
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
    
    func getCountObject(nameCollection: String, completionHandler: @escaping (_ result: Int) -> ()) {
        db.collection(nameCollection).getDocuments() { (querySnapshot, err) in
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
                        for (key, value) in document.data() {
                            switch key {
                            case "birthday":
                                user.birthday = value as? String
                            case "place":
                                user.place = value as? String
                            case "id":
                                user.id = value as? String
                            case "listIdFollowers":
                                user.listIdFollowers = value as? [String]
                            case "listIdFollowing":
                                user.listIdFollowing = value as? [String]
                            case "name":
                                user.name = value as? String
                            case "avatar":
                                user.nameImage = value as? String
                            case "job":
                                user.job = value as? String
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
                        for (key, value) in document.data() {
                            switch key {
                            case "id":
                                post.id = value as? String
                            case "idUser":
                                post.idUser = value as? String
                            case "listImage":
                                post.listImage = value as? [String]
                            case "content":
                                post.content = value as? String
                            case "date":
                                post.date = value as? String
                            case "listIdHeart":
                                post.listIdHeart = value as? [String]
                            case "place":
                                post.place = value as? String
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
                        for (key, value) in document.data() {
                            switch key {
                            case "birthday":
                                user.birthday = value as? String
                            case "place":
                                user.place = value as? String
                            case "id":
                                user.id = value as? String
                            case "listIdFollowers":
                                user.listIdFollowers = value as? [String]
                            case "listIdFollowing":
                                user.listIdFollowing = value as? [String]
                            case "name":
                                user.name = value as? String
                            case "avatar":
                                user.nameImage = value as? String
                            case "job":
                                user.job = value as? String
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
