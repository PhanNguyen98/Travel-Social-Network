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
    
    func setData(text: String, keyData: String) {
        var arrayData = [String]()
        arrayData = getData(keyData: keyData)
        if arrayData.first(where: { $0 == text }) == nil && text != "" {
            arrayData.append(text)
            userManager.setValue(arrayData, forKey: keyData)
        }
    }
    
    func getData(keyData: String) -> [String] {
        guard let data: [String] = userManager.array(forKey: keyData) as? [String] else {
            return [String]()
        }
        return data
    }
    
    func deleteItem(key: String, keyData: String) {
        var arrData = [String]()
        arrData = getData(keyData: keyData)
        if let indexOfKey = arrData.firstIndex(of: key) {
            arrData.remove(at: indexOfKey)
        }
        userManager.setValue(arrData, forKey: keyData)
    }
}
