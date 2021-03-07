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
    
    func setData(text: String) {
        var arrayData = [String]()
        arrayData = getData()
        if arrayData.first{ $0 == text } == nil && text != "" {
            arrayData.append(text)
            userManager.setValue(arrayData, forKey: "ListKeySearch")
        }
    }
    
    func getData() -> [String] {
        guard let data: [String] = userManager.array(forKey: "ListKeySearch") as? [String] else {
            return [String]()
        }
        return data
    }
    
    func deleteItem(key: String) {
        var arrData = [String]()
        arrData = getData()
        for index in 0..<arrData.count {
            if arrData[index] == key {
                arrData.remove(at: index)
            }
        }
        userManager.setValue(arrData, forKey: "ListKeySearch")
    }
}
