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
        
        // max 10 views lol
        ZStack {
            BackgroundView(isNight: $isNight)
                    
            VStack {
                CityTextView(name: "Danzig")
                MainWeatherStatusView(
                    weather: $weather,
                    imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill"
                )
                
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
                }
                
                Spacer()
                
                Button(action: {
                    isNight.toggle()
                }, label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                })
            
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
}

#Preview {
    ContentView()
}

struct WeatherDay: View {
    var dayOfWeek: String?
    var imageName: String?
    var temperatire: Float?
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayOfWeek ?? "")
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            Image(systemName: imageName ?? "")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperatire ?? 0.0, specifier: "%.1f")°")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors: [
                isNight ? .black : .blue,
                isNight ? .gray : Color("lightBlue")
            ]
        ),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView : View {
    var name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding(.bottom)
    }
}

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
                
            Text("\(weather?.current.temperature2m ?? 0.0, specifier: "%.1f")°")
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 40)
    }
}

func getWeather() async throws -> WeatherData {
    let danzigLat = 54.3523
    let danzigLon = 18.6491
    
    guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(danzigLat)&longitude=\(danzigLon)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=GMT") else { throw CustomError.invalidURL }

    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw CustomError.invalidRepsonse
    }
    
    print("JSON: \(String(data: data, encoding: .utf8))")
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(WeatherData.self, from: data)
    } catch {
        print("Error: \(error)")
        throw CustomError.invalidData
    }
}

struct WeatherData: Codable {
    let current: Current
    let daily: Daily

    struct Current: Codable {
        let time: String
        let interval: Int
        let temperature2m: Float
        let weatherCode: Int
        enum CodingKeys: String, CodingKey {
            case time
            case interval
            case temperature2m = "temperature_2m"
            case weatherCode
        }
    }

    struct Daily: Codable {
        let time: [String]
        let weatherCode: [Int]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}

enum CustomError : Error {
    case invalidURL
    case invalidRepsonse
    case invalidData
}

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

func formattedDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: dateString) else { return dateString }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "EEEE"
    return outputFormatter.string(from: date)
}
