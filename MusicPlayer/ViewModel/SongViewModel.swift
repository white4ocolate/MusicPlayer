//
//  SongViewModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation

class SongViewModel: ObservableObject {
//    @Published var songs: [SongModel] = [
//        SongModel(trackName: "GhostBusters", data: Data(), artist: "Ray Parker Jr.Da", coverImage: Data(), duration: 0),
//        SongModel(trackName: "Lose Yourself", data: Data(), artist: "Eminem", coverImage: Data(), duration: 0),
//        SongModel(trackName: "I dont understand", data: Data(), artist: "Papich", coverImage: Data(), duration: 0)
//    ]
    @Published var songs: [SongModel] = []
}
