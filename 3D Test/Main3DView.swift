//
//  Main3DView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 7/4/25.
//

import Foundation
import SwiftUI

struct Main3DView: View {
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    var body: some View {
        VStack(spacing: 10) {

            Model3DView(modelName: modelName)
                .background(Color.clear)
                .frame(width: 250, height: 250) // Made even larger for better visibility
            
        }
        .background(Color.clear)
    }
}
