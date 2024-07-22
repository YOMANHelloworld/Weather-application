//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    ZStack {
                        Image("wall")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 10)
                        
                        if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 10) {
                                    ForEach(0..<hourlyData.count) { index in
                                        HourWeatherView(num: index)
                                    }
                                }
                                
                            }
                            .frame(height: 180)
                        }

                    }
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    VStack {
                        if let dailyData = weatherMapViewModel.weatherDataModel?.daily {
                            List {
                                ForEach(0..<dailyData.count) { index in
                                    DailyWeatherView(num: index)
                                }
                            }
                            .listStyle(GroupedListStyle())
                            .frame(height: 500)
                        .padding(.top)
                        } else {
                            Text("No connection")
                        }
                    }
                }
            
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                        Text("Weather Forecast for \(weatherMapViewModel.city)").font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView().environmentObject(WeatherMapViewModel())
    }
}
