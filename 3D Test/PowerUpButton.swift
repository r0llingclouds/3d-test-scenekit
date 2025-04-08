//
//  WeatherButton.swift
//  3D Test
//
//  Created by Tirso López Ausens on 5/4/25.
//

import Foundation
import SwiftUI

struct PowerUpButton: View {
    
    var title: String
    
    var body: some View {
        Button(action: {
            print("Power up!")
        }) {
            Text(title)
                .frame(width: 280, height: 50)
                .background(Color.red)
                .foregroundColor(Color.white)
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(10)
        }
        .padding(.bottom, 20)
    }
}
