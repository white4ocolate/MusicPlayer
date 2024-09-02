//
//  SongModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation

struct SongModel: Identifiable {
    let id: String = UUID().uuidString
    var trackName: String
    var data: Data
    var artist: String?
    var coverImage: Data?
    var duration: TimeInterval?
}
