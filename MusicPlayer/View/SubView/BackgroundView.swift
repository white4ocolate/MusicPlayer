//
//  BackgroundView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.topBackground, .bottomBackground],
            startPoint: .topTrailing,
            endPoint: .bottomLeading)
        .ignoresSafeArea()
    }
}
