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
    @State var isShowFiles = false
    
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
                        isShowFiles.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    })
                }
            })
            
            //MARK: - Files Sheet
            .sheet(isPresented: $isShowFiles, content: {
                ImportFileManager(songs: $songVM.songs)
            })
        }
    }
}

#Preview {
    PlayerView()
}
