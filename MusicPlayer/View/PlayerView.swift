//
//  ContentView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI
import RealmSwift

struct PlayerView: View {
    
    //MARK: - Properties
    @ObservedResults(SongModel.self) var songs
    @StateObject var songVM: SongViewModel = SongViewModel()
    @State private var isShowFiles: Bool = false
    @State private var isShowFullPlayer: Bool = false
    @Namespace private var playerAnimation
    
    var frameBackground: CGFloat {
        isShowFullPlayer ? 320 : 40
    }
    var spaceMiniplayer: CGFloat {
        songVM.isPlaying ? 20 : 17
    }
    
    //MARK: - View
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    //MARK: - List of songs
                    List {
                        ForEach(songs) { song in
                            SongView(song: song, durationFormated: songVM.durationFormated)
                                .onTapGesture {
                                    if songVM.currentSong != song {
                                        songVM.playAudio(song: song)
                                    }
                                }
                        }
                        .onDelete(perform: songVM.deleteSong)
                    }
                    .listStyle(.plain)
                    .foregroundStyle(.white)
//                    .safeAreaInset(edge: .bottom) {
                        
                        //MARK: - Player
                        if (songVM.currentSong != nil) {
                            Player()
                                .frame(height: isShowFullPlayer ? SizeConstants.fullPlayer : SizeConstants.miniPlayer)
                                .onTapGesture {
                                    withAnimation(.spring) {
                                        self.isShowFullPlayer.toggle()
                                    }
                                }
                        }
//                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowFiles.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    })
                }
            })
            .toolbarBackground(Color.topBackground)
            
            //MARK: - Files Sheet
            .sheet(isPresented: $isShowFiles, content: {
                ImportFileManager()
                    .ignoresSafeArea()
            })
        }
    }
    
    //MARK: - Methods
    private func Player() -> some View {
        VStack {
            //MARK: - Mini player
            HStack {
                
                SongImageView(imageData: songVM.currentSong?.coverImage, size: frameBackground)
                
                if !isShowFullPlayer {
                    VStack(alignment: .leading) {
                        SongDescription()
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    Spacer()
                    
                    HStack(spacing: spaceMiniplayer) {
                        CustomButton(image: "backward.end", size: .title2) {
                            songVM.backward()
                        }
                        CustomButton(image: songVM.isPlaying ? "pause" : "play", size: .title) {
                            songVM.playPause()
                        }
                        CustomButton(image: "forward.end", size: .title2) {
                            songVM.forward()
                        }
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(isShowFullPlayer ? .clear : .black.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
            
            //MARK: - Full player
            if isShowFullPlayer {
                VStack {
                    /// Description
                    VStack {
                        SongDescription()
                    }
                    .foregroundStyle(.white)
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    VStack {
                        /// Duration
                        HStack {
                            Text("\(songVM.durationFormated(songVM.currentTime))")
                            Spacer()
                            Text("\(songVM.durationFormated(songVM.totalTime))")
                        }
                        .durationFont()
                        .padding()
                        
                        ///Slider
                        Slider(value: $songVM.currentTime, in: 0...songVM.totalTime) { editing in
                            if !editing {
                                songVM.seekTime(time: songVM.currentTime)
                            }
                        }
                        .offset(y: -18)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                songVM.updateProgress()
                            }
                        }
                        .padding(.bottom, 70)
                        
                        HStack(spacing: 40) {
                            CustomButton(image: "backward.end.fill", size: .title2) {
                                songVM.backward()
                            }
                            CustomButton(image: songVM.isPlaying ? "pause.circle.fill" : "play.circle.fill", size: .largeTitle) {
                                songVM.playPause()
                            }
                            CustomButton(image: "forward.end.fill", size: .title2) {
                                songVM.forward()
                            }
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    private func CustomButton(image: String, size: Font, action: @escaping ()->()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .foregroundStyle(.white)
                .font(size)
        })
    }
    
    @ViewBuilder
    private func SongDescription() -> some View {
        if let currentSong = songVM.currentSong {
            Text(currentSong.trackName)
                .font(.title3)
            Text(currentSong.artist ?? "unknown")
                .font(.subheadline)
        }
    }
}

#Preview {
    PlayerView()
}
