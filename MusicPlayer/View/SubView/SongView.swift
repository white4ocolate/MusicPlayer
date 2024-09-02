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
    
    //MARK: - View
    var body: some View {
        HStack {
            Color(.orange)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading) {
                Text(song.trackName)
                    .font(.title3)
                Text(song.artist ?? "unknown")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text("03:40")
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    SongView(song: SongModel(trackName: "A$AP-Money", data: Data(), artist: "LiL-Money", coverImage: Data(), duration: 0))
}
