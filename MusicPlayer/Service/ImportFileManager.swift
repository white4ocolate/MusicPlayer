//
//  ImportFileManager.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import Foundation
import SwiftUI
import AVFoundation

/// Allows choose and import audio fles.
struct ImportFileManager: UIViewControllerRepresentable {
    
    @Binding var songs: [SongModel]
    /// Coordinator manages tasks between SwiftUI and UIKit.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /// Creates and configures UIDocumentPickerViewController which uses for selection audiofiles.
    func makeUIViewController(context: Context) -> some UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        
        picker.delegate = context.coordinator
        
        return picker
    }
    
    /// Intended for update Controller with new data.
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    /// Coordinator is a link between UIDocumentPicker and ImportFileManager.
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: ImportFileManager
        
        init(parent: ImportFileManager) {
            self.parent = parent
        }
        
        /// Calls when user select file.
        /// Processes selected url, creates song type SongModel and adds it in array songs.
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                let document = try Data(contentsOf: url)
                let asset = AVAsset(url: url)
                var song = SongModel(trackName: url.lastPathComponent, data: document)
                
                Task {
                    let metaData = try await asset.load(.metadata)
                    
                    for item in metaData {
                        guard let key = item.commonKey?.rawValue, let value = try await item.load(.value) else { continue }
                        switch key {
                        case AVMetadataKey.commonKeyArtist.rawValue:
                            song.artist = value as? String
                        case AVMetadataKey.commonKeyArtwork.rawValue:
                            song.coverImage = value as? Data
                        case AVMetadataKey.commonKeyTitle.rawValue:
                            song.trackName = value as? String ?? song.trackName
                        default:
                            break
                        }
                    }
                    song.duration = CMTimeGetSeconds(try await asset.load(.duration))
                    if !self.parent.songs.contains(where: { $0.trackName == song.trackName }) {
                        await MainActor.run {
                            self.parent.songs.append(song)
                        }
                    } else {
                        print("Song is exists already")
                    }
                }
                
            } catch {
                print("Error processing file: \(error.localizedDescription)")
            }
        }
    }
}
