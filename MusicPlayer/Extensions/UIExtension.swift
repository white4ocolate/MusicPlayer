//
//  UIExtension.swift
//  MusicPlayer
//
//  Created by white4ocolate on 03.09.2024.
//

import SwiftUI

struct DurationFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
    }
}

extension View {
    func durationFont() -> some View {
        self.modifier(DurationFontModifier())
    }
}
