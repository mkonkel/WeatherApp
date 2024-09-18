//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Michal Konkel on 11/09/2024.
//

import SwiftUI

struct ContentView: View {
    typealias CustomError = API.CustomError
    
    @State private var isNight = false
    @State private var weather: WeatherData?

    var body: some View {
        // max 10 views lol - use @ViewBuilder func (with parameters) or var (without parameters view) to seperate groups of views.
        ZStack {
            BackgroundView(isNight: $isNight)

            VStack {
                headerView()

                weatherView()

                Spacer()

                weatherButton()

                Spacer()
            }
        }
        .task {
            do {
                weather = try await API.getWeather()
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
        cityTextView(name: "Danzig")

        MainWeatherStatusView(
            weather: $weather,
            imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill"
        )
    }

    @ViewBuilder private func weatherView() -> some View {
        HStack(spacing: 20) {
            if let weather {
                ForEach(0 ..< weather.daily.time.count, id: \.self) { index in
                    WeatherDay(
                        dayOfWeek: formattedDate(weather.daily.time[index]),
                        imageName: weatherIconName(for: weather.daily.weatherCode[index]),
                        temperatire: weather.daily.temperature2mMax[index]
                    )
                }
            } else {
                Text("Loading...")
            }
        }
    }

    @ViewBuilder private func weatherButton() -> some View {
        Button(action: {
            isNight.toggle()
        }, label: {
            WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
        })
    }

    @ViewBuilder private func cityTextView(name: String) -> some View {
        Text(name)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding(.bottom)
    }

    private func weatherIconName(for weatherCode: Int) -> String {
        switch weatherCode {
        case 1 ... 3:
            "sun.max.fill" // Słonecznie
        case 45:
            "cloud.drizzle.fill" // Mgła lub mżawka (kod WMO 45)
        case 61 ... 67:
            "cloud.rain.fill" // Deszcz
        default:
            "questionmark.circle" // Nieznany kod
        }
    }

    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE"
        return outputFormatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
