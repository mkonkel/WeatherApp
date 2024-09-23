//
//  DateFormatter.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 23/09/2024.
//

import Foundation

func formattedDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: dateString) else { return dateString }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "EEEE"
    return outputFormatter.string(from: date)
}
