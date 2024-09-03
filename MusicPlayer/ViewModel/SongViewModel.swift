//
//  SongViewModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation
import AVFoundation

class SongViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var songs: [SongModel] = []
    
    //MARK: - Methods
    func durationFormated(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration) ?? "00:00"
    }
}
