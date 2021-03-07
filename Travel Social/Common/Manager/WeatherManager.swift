//
//  WeatherManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import Foundation
import Alamofire

class WeatherManager {
    static let shared = WeatherManager()
    private init() {
    }
    
    func searchWeather(name: String, completionHandler: @escaping (_ result: Result<Forecast?, ResponseError>) -> ()) {
        APIManager.shared.call(type: WeatherAPI.search(name)) { (result: Result<Forecast?, ResponseError>) in
            switch result {
            case .success(let weather):
                completionHandler(.success(weather))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
