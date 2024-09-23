//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 13/09/2024.
//

import Foundation
import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
            Text(title)
                .frame(width: 280, height: 50)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .font(.system(size: 20, weight: .bold, design: .default))
                .cornerRadius(10)
            
        }
}

#Preview {
     ZStack {
         Color.gray

         WeatherButton(title: "Hello", textColor: .black, backgroundColor: .white)
     }
     .ignoresSafeArea()
 }
