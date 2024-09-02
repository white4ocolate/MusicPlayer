//
//  ContentView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            List {
                HStack {
                    Color(.orange)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    VStack(alignment: .leading) {
                        Text("Track Name")
                            .font(.title3)
                        Text("Artist")
                            .font(.subheadline)
                    }
                    Spacer()
                    Text("03:40")
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }.listStyle(.plain)
        }
    }
}

#Preview {
    PlayerView()
}
