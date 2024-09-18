//
//  BackgroundView.swift
//  SwiftUI-Weather
//
//  Created by Kamil Szuba on 18/09/2024.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var isNight: Bool

    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    isNight ? .black : .blue,
                    isNight ? .gray : Color("lightBlue")
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundView(isNight: .constant(false))
}
