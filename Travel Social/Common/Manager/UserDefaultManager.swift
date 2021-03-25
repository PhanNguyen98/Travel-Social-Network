//
//  UserDefaultManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 01/02/2021.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    let userManager = UserDefaults.standard
   
    private init() {
    }
    
    func setDataNotify(data: Int, keyData: String) {
        userManager.setValue(data, forKey: keyData)
    }
    
    func getDataNotify(keyData: String) -> Int {
        guard let data: Int = userManager.integer(forKey: keyData) as? Int else {
            return 0
        }
        return data
    }
    
    func setDataUser(data: String, keyData: String) {
        userManager.setValue(data, forKey: keyData)
    }
    
    func getData(keyData: String) -> String {
        guard let data = userManager.string(forKey: keyData) else {
            return ""
        }
        return data
    }
    
}
