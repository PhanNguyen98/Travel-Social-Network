//
//  ResponseError.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import Foundation

class ResponseError: Codable, Error {
    var message: String?
}
