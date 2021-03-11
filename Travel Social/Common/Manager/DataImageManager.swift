//
//  DataImageManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/01/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher

class DataImageManager {
    static let shared = DataImageManager()
    
    private let storageRef = Storage.storage().reference()
    
    private init(){
    }
    
    func uploadsImage(image: UIImage, place: String, nameImage: String, completion: @escaping (_ result: String) -> ()) {
        let imageRef = storageRef.child(place).child(nameImage)
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
                completion("Upload Image Error")
            } else {
                completion("Upload Image Success")
            }
        }
    }
    
    func downloadImage(path: String, nameImage: String, completionHandler: @escaping (_ result: UIImage) -> ()) {
        let imageRef = storageRef.child(path).child(nameImage)
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error)
            } else {
                let result = UIImageView()
                result.kf.setImage(with: url)
                completionHandler(result.image ?? UIImage())
            }
        }
    }
}
