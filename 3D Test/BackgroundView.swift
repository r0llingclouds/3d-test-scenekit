//
//  BackgroundView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 7/4/25.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
}
