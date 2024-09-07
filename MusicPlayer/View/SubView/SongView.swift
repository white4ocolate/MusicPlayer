//
//  SongView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI

struct SongView: View {
    
    //MARK: - Properties
    let song: SongModel
    let durationFormated: (TimeInterval) -> String
    
    //MARK: - View
    var body: some View {
        HStack {
            
            SongImageView(imageData: song.coverImage, size: 60)
            
            VStack(alignment: .leading) {
                Text(song.trackName)
                    .font(.title3)
                Text(song.artist ?? "unknown")
                    .font(.subheadline)
            }
            
            Spacer()
            
            if let duration = song.duration {
                Text("\(durationFormated(duration))")
                
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
