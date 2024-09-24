//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 11/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isNight = false
    @State private var weather: WeatherData?
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            
            VStack {
                headerView()
                weatherView()
                Spacer()
                weatherButtonView()
                Spacer()
            }
        }
        .task {
            do {
                weather = try await getWeather()
            } catch CustomError.invalidData {
                print("Invalid Data")
            } catch CustomError.invalidRepsonse {
                print("Invalid Response")
            } catch CustomError.invalidURL {
                print("Invalid URL")
            } catch {
                print("Unexpected Error")
            }
        }
    }
    
    @ViewBuilder private func headerView() -> some View {
        CityTextView(name: "Danzig")
        MainWeatherStatusView(
            weather: $weather,
            imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill"
        )
    }
    
    @ViewBuilder private func weatherView() -> some View {
        HStack(spacing: 20) {
            if let weather = weather {
                ForEach(0..<weather.daily.time.count, id: \.self) { index in
                    WeatherDay(
                        dayOfWeek: formattedDate(weather.daily.time[index]),
                        imageName: weatherIconName(for: weather.daily.weatherCode[index]),
                        temperatire: weather.daily.temperature2mMax[index]
                    )
                }
            } else {
                Text("Loading...")
            }
        }.padding(20)
    }
    
    @ViewBuilder private func weatherButtonView() -> some View {
        Button(action: {
            isNight.toggle()
        }, label: {
            WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
        })
    }
}

#Preview {
    ContentView()
}
