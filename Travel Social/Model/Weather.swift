//
//  Weather.swift
//  Travel Social
//
//  Created by Phan Nguyen on 03/03/2021.
//

import Foundation

struct Forecast: Codable {
    var city: City?
    var list: [Weather]?
}

struct Weather: Codable {
    var temp: Temp?
    var weather: [Icon]?
    var wind: Wind?
    
    enum CodingKeys: String, CodingKey {
        case temp = "main"
        case weather
        case wind
    }
}

struct City: Codable {
    var name: String?
}

struct Wind: Codable {
    var speed: Float?
}

struct Temp: Codable {
    var tempMax: Float?
    var tempMin: Float?
    var pressure: Float?
    var humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case pressure
        case humidity
    }
}

struct Icon: Codable {
    var icon: String?
    var description: String?
}
