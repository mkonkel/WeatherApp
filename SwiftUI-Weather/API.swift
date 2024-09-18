//
//  API.swift
//  SwiftUI-Weather
//
//  Created by Kamil Szuba on 18/09/2024.
//

import Foundation

enum API {
    enum CustomError: Error {
        case invalidURL
        case invalidRepsonse
        case invalidData
    }
}

extension API {
    static func getWeather() async throws -> WeatherData {
        let danzigLat = 54.3523
        let danzigLon = 18.6491

        guard let url =
            URL(
                string: "https://api.open-meteo.com/v1/forecast?latitude=\(danzigLat)&longitude=\(danzigLon)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=GMT"
            )
        else { throw CustomError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CustomError.invalidRepsonse
        }

        print("JSON: \(String(data: data, encoding: .utf8))")

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            print("Error: \(error)")
            throw error // CustomError.invalidData
        }
    }
}
