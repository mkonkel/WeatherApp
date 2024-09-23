//
//  CityView.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 23/09/2024.
//

import Foundation
import SwiftUI

struct CityTextView : View {
    var name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 42, weight: .bold, design: .default))
            .foregroundColor(.white)
            .padding(.bottom)
    }
}
