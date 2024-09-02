//
//  ContentView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI

struct PlayerView: View {
    
    //MARK: - Properties
    @StateObject var songVM = SongViewModel()
    
    //MARK: - View
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                List {
                    ForEach(songVM.songs) { song in
                        SongView(song: song)
                    }
                }
                .listStyle(.plain)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    })
                }
            })
        }
    }
}

#Preview {
    PlayerView()
}
