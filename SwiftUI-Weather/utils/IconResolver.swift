//
//  IconResolver.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 23/09/2024.
//

import Foundation

func weatherIconName(for weatherCode: Int) -> String {
    switch weatherCode {
    case 1...3:
        return "sun.max.fill" // Słonecznie
    case 45:
        return "cloud.drizzle.fill" // Mgła lub mżawka (kod WMO 45)
    case 61...67:
        return "cloud.rain.fill" // Deszcz
    default:
        return "questionmark.circle" // Nieznany kod
    }
}
