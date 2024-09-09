//
//  SongModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation
import RealmSwift

class SongModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var trackName: String
    @Persisted var data: Data
    @Persisted var artist: String?
    @Persisted var coverImage: Data?
    @Persisted var duration: TimeInterval?
    
    convenience init(trackName: String, data: Data, artist: String? = nil, coverImage: Data? = nil, duration: TimeInterval? = nil) {
        self.init()
        self.trackName = trackName
        self.data = data
        self.artist = artist
        self.coverImage = coverImage
        self.duration = duration
    }
}
