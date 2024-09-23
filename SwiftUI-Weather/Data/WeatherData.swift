//
//  WeatherData.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 21/09/2024.
//

import Foundation

struct WeatherData: Codable {
    let current: Current
    let daily: Daily

    struct Current: Codable {
        let time: String
        let interval: Int
        let temperature2m: Float
        let weatherCode: Int
     
        enum CodingKeys: String, CodingKey {
            case time
            case interval
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }

    struct Daily: Codable {
        let time: [String]
        let weatherCode: [Int]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        
        enum CodingKeys: String, CodingKey {
            case time
            case weatherCode = "weather_code"
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
        }
    }

}
