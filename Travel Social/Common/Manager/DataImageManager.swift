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
    
    private let storageRef = Storage.storage().reference()
    
    private init(){
    }
    
    func uploadsImage(image: UIImage, place: String, nameImage: String, completion: @escaping (_ result: Result<String?, Error>) -> ()) {
        let imageRef = storageRef.child(place).child(nameImage)
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let url = url {
                        completion(.success(String(url.absoluteString)))
                    } else {
                        guard let error = error else { return }
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
}
