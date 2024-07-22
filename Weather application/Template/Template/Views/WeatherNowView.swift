//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    @State private var leftTextOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var rightTextOffset: CGFloat = UIScreen.main.bounds.width
    @State private var topTextOffset: CGFloat = UIScreen.main.bounds.height
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Image("wall")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 7)
                
                VStack{
                    VStack{
                        HStack {
                            TextField("Enter New Location Weather", text: $temporaryCity)
                                .onSubmit {
                                    weatherMapViewModel.city = temporaryCity
                                    Task {
                                        do {
                                            try? await weatherMapViewModel.getCoordinatesForCity()
                                            try? await weatherMapViewModel.loadData(lat: weatherMapViewModel.coordinates?.latitude ?? 0.0, lon: weatherMapViewModel.coordinates?.longitude ?? 0.0)
                                        } catch {
                                            print("Error: \(error)")
                                            isLoading = false
                                        }
                                    }
                                    
                                    // Reset offsets and trigger animations
                                    leftTextOffset = -UIScreen.main.bounds.width
                                    rightTextOffset = UIScreen.main.bounds.width
                                    topTextOffset = UIScreen.main.bounds.height
                                    
                                    withAnimation(.easeInOut(duration: 0.75)) {
                                        leftTextOffset = 0
                                        rightTextOffset = 0
                                    }
                                    
                                    withAnimation(.easeInOut(duration: 1.25)) {
                                        leftTextOffset = 0
                                    }
                                    
                                    withAnimation(.easeInOut(duration: 1.75)) {
                                        topTextOffset = 0
                                    }
                                    
                                }
                        }//search bar
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        
                        HStack{
                            VStack{
                                if let forecast = weatherMapViewModel.weatherDataModel {
                                    Text("\((Double)(forecast.current.temp), specifier: "%.0f") ºC")
                                        
                                } else {
                                    Text("N/A")
                                        
                                }
                                
                                Text(weatherMapViewModel.city)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .bold()
                            .padding(27)
                            .font(.custom("Arial", size: 24))
                            .offset(x: leftTextOffset)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    leftTextOffset = 0
                                }
                            }
                            
                            VStack{
                                let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
                                let timeZoneIdentifier = weatherMapViewModel.weatherDataModel?.timezone
                                let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp, timeZoneIdentifly: timeZoneIdentifier ?? "Europe/London")
                                
                                Text(formattedDate)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .bold()
                            .padding(27)
                            .font(.custom("Arial", size: 24))
                            .offset(x: rightTextOffset)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    rightTextOffset = 0 // Animate to the final position
                                }
                            }
                        }//time and temp
                        
                        HStack{
                            // Weather Description
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapViewModel.weatherDataModel?.current.weather[0].icon ?? "")@2x.png")) {
                                image in image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Text(forecast.current.weather[0].weatherDescription.rawValue)
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("Description: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                            
                        }//description
                        .offset(x: leftTextOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                leftTextOffset = 0
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.bottom)
                        .padding(25)
                        
                        HStack {
                            // Wind Speed icon
                            WeatherIcon(image: "wind.snow", values: "\(Int(weatherMapViewModel.weatherDataModel?.current.windSpeed ?? 0))%", labels: "Wind Speed")
                            
                            // Pressure icon
                            WeatherIcon(image: "speedometer", values: "\(Int(weatherMapViewModel.weatherDataModel?.current.pressure ?? 0))hPa", labels: "Pressure")
                            
                            // Humidity icon
                            WeatherIcon(image: "dehumidifier", values: "\(Int(weatherMapViewModel.weatherDataModel?.current.humidity ?? 0))%", labels: "Humidity")
                            
                        }//bottom tab
                        .padding(15)
                        .foregroundColor(.black)
                        .offset(y: topTextOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                topTextOffset = 0
                            }
                        }
                    }//VS2
                    .padding(10)
                }
            }// VS1
        }
    }
}

struct WeatherIcon: View {
    let image: String
    let values: String
    let labels: String

    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .frame(width: 60, height: 60)

            Text(values)
                .font(.system(size: 22, weight: .medium))

            Text(labels)
                .font(.system(size: 14, weight: .medium))
        }
        .padding()
    }
}

struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView().environmentObject(WeatherMapViewModel())
    }
}
