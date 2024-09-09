//
//  SongViewModel.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation
import AVFoundation
import RealmSwift

class SongViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    //MARK: - Properties
    @ObservedResults(SongModel.self) var songs
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentIndex: Int?
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    @Published var isRepeat: Bool = false
    @Published var isShuffle: Bool = false
    
    var currentSong: SongModel? {
        get {
            guard let currentIndex = currentIndex, songs.indices.contains(currentIndex) else { return nil }
            return songs[currentIndex]
        }
        set {
            if newValue == nil {
                currentIndex = nil
            }
            else if let newSong = newValue, let index = songs.firstIndex(of: newSong) {
                currentIndex = index
            }
        }
    }
    
    //MARK: - Methods
    func durationFormated(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration) ?? "00:00"
    }
    
    func playAudio(song: SongModel) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: song.data)
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            isPlaying = true
            totalTime = audioPlayer?.duration ?? 0.0
            if let index = songs.firstIndex(where: { $0.id == song.id }) {
                currentIndex = index
            }
        } catch {
            print("Error in play audio: \(error.localizedDescription)")
        }
    }
    
    func seekTime(time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func updateProgress() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    func playPause() {
        if isPlaying {
            self.audioPlayer?.pause()
        } else {
            self.audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func stopAudio() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        isPlaying = false
    }
    
    func forward() {
        var nextIndex = 0
        guard let currentIndex = currentIndex else { return }
        if isRepeat {
            nextIndex = currentIndex
        } else {
            if isShuffle {
                nextIndex = Int.random(in: 0..<songs.count)
            } else {
                nextIndex = currentIndex + 1 < songs.count ? currentIndex + 1 : 0
            }
        }
        playAudio(song: songs[nextIndex])
        
    }
    
    func backward() {
        var previoustIndex = 0
        guard let currentIndex = currentIndex else { return }
        if isRepeat {
            previoustIndex = currentIndex
        } else {
            previoustIndex = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        }
        playAudio(song: songs[previoustIndex])
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            forward()
        }
    }
    
    func deleteSong(indexSet: IndexSet) {
        if let first = indexSet.first {
            if self.currentSong == songs[first] {
                self.currentSong = nil
                self.stopAudio()
            }
            //            songs.remove(at: first)
            $songs.remove(atOffsets: indexSet)
        }
    }
    
    func repeatSong() {
        isRepeat.toggle()
    }
    
    func shuffleSongs() {
        isShuffle.toggle()
    }
}
