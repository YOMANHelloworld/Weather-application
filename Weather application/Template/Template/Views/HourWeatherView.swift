//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    //var current: Current
    var num: Int
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(weatherMapViewModel.weatherDataModel?.hourly[num].dt ?? 0))
        VStack {
            Text(formattedDate)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding([.top, .horizontal])
                .foregroundColor(.white)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapViewModel.weatherDataModel?.hourly[num].weather[0].icon ?? "")@2x.png")) {
                image in image
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.horizontal)
            } placeholder: {
                ProgressView()
            }
            
            Text("\(Double(weatherMapViewModel.weatherDataModel?.hourly[num].temp ?? 0.0), specifier: "%.0f") ºC")
                .frame(width: 100)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.white)
            
            Text("\(String(weatherMapViewModel.weatherDataModel?.hourly[num].weather[0].weatherDescription.rawValue ?? "N/A"))")
                .frame(width: 100, height: 50)
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(2)                .padding([.horizontal, .bottom])
                .foregroundColor(.white)
        }
        .background(Color(hex: "#7b21de"))
        .opacity(0.8)
        .cornerRadius(15)
        .padding(.top)
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
