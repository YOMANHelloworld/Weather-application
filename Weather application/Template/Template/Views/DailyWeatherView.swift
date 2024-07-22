//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    //var day: Daily
    var num: Int
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    
    var body: some View {

        let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(weatherMapViewModel.weatherDataModel?.daily[num].dt ?? 0))
        
        HStack {
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapViewModel.weatherDataModel?.daily[num].weather[0].icon ?? "")@2x.png")) {
                image in image
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }

            Spacer()
            
            VStack {
                Text(weatherMapViewModel.weatherDataModel?.daily[num].weather[0].weatherDescription.rawValue ?? "N/A")
                    .font(.body) // Customize the font if needed
                    
                Text(formattedDate)
                    .font(.body) // Customize the font if needed
                    
            }
            
            Spacer()
            
            Text("\(Double(weatherMapViewModel.weatherDataModel?.daily[num].temp.max ?? 0.0), specifier: "%.0f") ºC / \(Double(weatherMapViewModel.weatherDataModel?.daily[num].temp.min ?? 0.0), specifier: "%.0f") ºC")
                .font(.body)
            
        }

    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var day = WeatherMapViewModel().weatherDataModel!.daily
    static var previews: some View {
        DailyWeatherView(num: 0)
    }
}

