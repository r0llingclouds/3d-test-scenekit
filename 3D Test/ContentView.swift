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
                CurrentLevelView(levelName: "Level 1")
                    .padding()
 
                Model3DView(modelName: "Pixel_Anime_Character_Female")
                    .padding()
                
                HStack(spacing: 20) {
                    levelForecast(dayOfWeek: "Lvl 1", icon: "cloud.sun.fill", temp: 12)
                    levelForecast(dayOfWeek: "Lvl 2", icon: "sun.max.fill", temp: 29)
                    levelForecast(dayOfWeek: "Lvl 3", icon: "wind", temp: 14)
                    levelForecast(dayOfWeek: "Lvl 4", icon: "sun.rain.fill", temp: 23)
                    levelForecast(dayOfWeek: "Lvl 5", icon: "moon.stars.fill", temp: 6)
                }
                .padding()
                      
                PowerUpButton(title: "Power Up")
                
                Spacer()
            }
        }
    }
    
    private func levelForecast(dayOfWeek: String, icon: String, temp: Int) -> some View {
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
