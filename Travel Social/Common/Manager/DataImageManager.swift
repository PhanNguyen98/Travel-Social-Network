//
//  DataImageManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 24/01/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class DataImageManager {
    static let shared = DataImageManager()
    
    let storageRef = Storage.storage().reference()
    
    private init(){
    }
    
    func uploadsImage(image: UIImage, place: String, nameImage: String) {
        let imageRef = storageRef.child(place).child(nameImage)
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        _ = imageRef.putData(data, metadata: nil) { [self] (metadata, error) in
            guard let metadata = metadata else { return }
            _ = metadata.size
            storageRef.downloadURL { (url, error) in
                guard url != nil else { return }
          }
        }
    }
    
    func downloadImage(path: String, nameImage: String, completionHandler: @escaping (_ result: UIImage) -> ()) {
        let imageRef = storageRef.child(path).child(nameImage)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let result = UIImage(data: data!){
                    completionHandler(result)
                }
            }
        }
    }
}
