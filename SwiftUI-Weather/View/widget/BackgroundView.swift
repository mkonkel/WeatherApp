//
//  BackgroundView.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 23/09/2024.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors: [
                isNight ? .black : .blue,
                isNight ? .gray : Color("lightBlue")
            ]
        ),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}
