//
//  ContentView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 5/4/25.

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @State private var isNight: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                CityTextView(cityName: "Level 1")
                    .padding()
                // Pass isNight to MainWeatherStatusView
                MainWeatherStatusView(imageName: "cloud.sun.fill", temperature: "SMP25", isNight: isNight)
                    .padding()
                
                HStack(spacing: 20) {
                    forecastDay(dayOfWeek: "Lvl 1", icon: "cloud.sun.fill", temp: 12)
                    forecastDay(dayOfWeek: "Lvl 2", icon: "sun.max.fill", temp: 29)
                    forecastDay(dayOfWeek: "Lvl 3", icon: "wind", temp: 14)
                    forecastDay(dayOfWeek: "Lvl 4", icon: "sun.rain.fill", temp: 23)
                    forecastDay(dayOfWeek: "Lvl 5", icon: "moon.stars.fill", temp: 6)
                }
                .padding()
                                
                Button {
                    isNight.toggle()
                    print("isNight is now: \(isNight)")
                } label: {
                    WeatherButton(title: "Power Up")
                }
                
                Spacer()
            }
        }
    }
    
    private func forecastDay(dayOfWeek: String, icon: String, temp: Int) -> some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temp)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

//struct BackgroundView: View {
//    var body: some View {
//
//        LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
//            .edgesIgnoringSafeArea(.all)
//    }
//}
struct BackgroundView: View {
    var body: some View {
        Image("level1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
}


// Updated CityTextView with white background
struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.red)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.8))
                    .shadow(radius: 2)
            )
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: String
    var isNight: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // Use the Model3DView with the correct model name
            Model3DView(modelName: "mario_ac", isNight: isNight)
                .background(Color.clear)
                .frame(width: 250, height: 250) // Made even larger for better visibility
            
        }
        .background(Color.clear)
    }
}

