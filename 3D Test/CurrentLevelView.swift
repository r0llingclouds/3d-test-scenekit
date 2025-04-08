//
//  CurrentLevelView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 7/4/25.
//

import Foundation
import SwiftUI

struct CurrentLevelView: View {
    var levelName: String
    
    var body: some View {
        Text(levelName)
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
