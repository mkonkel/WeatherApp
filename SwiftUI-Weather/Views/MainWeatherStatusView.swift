//
//  MainWeatherStatusView.swift
//  SwiftUI-Weather
//
//  Created by Kamil Szuba on 18/09/2024.
//

import SwiftUI

struct MainWeatherStatusView: View {
    @Binding var weather: WeatherData?
    var imageName: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)

            Text("\(weather?.current.temperature ?? 0.0, specifier: "%.1f")°")
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    ZStack {
        Color.gray
        
        MainWeatherStatusView(
            weather: .constant(.init(
                current: .init(time: "time", interval: 1, temperature: 30, weatherCode: 0),
                daily: .init(time: [], weatherCode: [], temperature2mMax: [], temperature2mMin: [])
            )),
            imageName: ""
        )
    }
    .ignoresSafeArea()
}
