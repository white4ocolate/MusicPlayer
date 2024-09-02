//
//  SongModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation

struct SongModel: Identifiable {
    let id: String = UUID().uuidString
    let trackName: String
    let data: Data
    let artist: String?
    let coverImage: Data?
    let duration: TimeInterval?
}
