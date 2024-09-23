//
//  WeatherDay.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 21/09/2024.
//

import Foundation
import SwiftUI

struct WeatherDay: View {
    var dayOfWeek: String?
    var imageName: String?
    var temperatire: Float?
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayOfWeek?.prefix(3) ?? "")
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            Image(systemName: imageName ?? "")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperatire ?? 0.0, specifier: "%.1f")°")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
     ZStack {
         Color.gray

         WeatherDay(dayOfWeek: "test", imageName: "", temperatire: 20)
     }
     .ignoresSafeArea()
 }
