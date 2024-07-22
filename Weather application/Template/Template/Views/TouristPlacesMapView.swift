//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    //@State var  mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    if weatherMapViewModel.coordinates != nil {
                        VStack{
                            Map(coordinateRegion: $weatherMapViewModel.region, showsUserLocation: false, annotationItems: locations){ place in
                                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)) {
                                    VStack{
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }
                            Text("Tourist Attractions in \(weatherMapViewModel.city)")
                                .font(.title)
                                .padding([.bottom, .horizontal])
                                .multilineTextAlignment(.center)
                            
                        }
                        .frame(height: 500)
                        .edgesIgnoringSafeArea(.all)
                    }
                    
                    ForEach(locations) { location in
                        if weatherMapViewModel.city == location.cityName{
                            VStack{
                                HStack{
                                    Image(location.imageNames[0])
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    
                                    Text(location.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                }
                                .padding(.bottom)
                                
                            }
                            .frame(height: 100)
                            .background(.white)
                            .padding(.leading, 50)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            // process the loading of tourist places
            locations = weatherMapViewModel.loadLocationsFromJSONFile(cityName: weatherMapViewModel.city) ?? []
            print("locations === \(locations)")
        }
    }
}


struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel())
    }
}
