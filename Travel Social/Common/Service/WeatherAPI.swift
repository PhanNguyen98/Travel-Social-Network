//
//  WeatherAPI.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case search(_: String)
}

extension WeatherAPI: TargetType {
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var path: String {
        switch self {
        case .search:
            return "forecast"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var url: URL {
        return URL(string: self.baseURL + self.path)!
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .search:
            return URLEncoding.default
        }
    }
    
    var params: Parameters {
        switch self {
        case .search(let city):
            return [
                "q": city,
                "appid": SeverPath.weatherAccessKey
            ]
        }
    }
    
}
