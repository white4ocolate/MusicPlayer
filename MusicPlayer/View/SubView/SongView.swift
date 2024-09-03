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
            if let data = song.coverImage, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                ZStack{
                    Color.purple
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    Image(systemName: "music.note")
                        .resizable()
                        .frame(width: 22, height: 30)
                }
                
            }
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
