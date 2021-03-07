//
//  APIManager.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import Foundation
import Alamofire

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var params: Parameters { get }
}

class APIManager {
    static let shared = APIManager()
    
    private init() {
    }
    
    func call<T>(type: TargetType, params: Parameters? = nil, completionHandler: @escaping (_ result: Result<T?, ResponseError>) -> ()) where T: Codable {
        AF.request(type.url, method: type.httpMethod, parameters: type.params, encoding: type.encoding, headers: type.headers).validate().responseJSON { data in
            switch data.result {
            case .success(_):
                let decoder = JSONDecoder()
                if let jsonData = data.data {
                    let result = try! decoder.decode(T.self, from: jsonData)
                    completionHandler(.success(result))
                }
                break
            case .failure(_):
                let decoder = JSONDecoder()
                if let jsonData = data.data {
                    let error = try! decoder.decode(ResponseError.self, from: jsonData)
                    completionHandler(.failure(error))
                }
                break
            }
            
        }
                    
    }
}
