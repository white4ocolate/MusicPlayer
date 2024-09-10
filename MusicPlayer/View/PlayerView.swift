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
    var spaceMiniplayer: CGFloat = 30
    
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
                    
                    //MARK: - Player
                    if (songVM.currentSong != nil) {
                        Player()
                            .frame(height: isShowFullPlayer ? SizeConstants.fullPlayer : SizeConstants.miniPlayer)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    self.isShowFullPlayer.toggle()
                                }
                            }
                            .gesture(
                                    DragGesture()
                                        .onEnded { value in
                                            if value.translation.height > 50 {
                                                withAnimation(.spring) {
                                                    self.isShowFullPlayer.toggle()
                                                }
                                            }
                                        }
                                )
                    }
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
                        CustomButton(image: "backward.end", size: 20) {
                            songVM.backward()
                        }
                        .matchedGeometryEffect(id: "Backward", in: playerAnimation)
                        CustomButton(image: songVM.isPlaying ? "pause.fill" : "play", size: 30) {
                            songVM.playPause()
                        }
                        .matchedGeometryEffect(id: "Play", in: playerAnimation)
                        CustomButton(image: "forward.end", size: 20) {
                            songVM.forward()
                        }
                        .matchedGeometryEffect(id: "Forward", in: playerAnimation)
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
                    .padding(.bottom, 20)
                    
                    VStack {
                        /// Duration
                        HStack {
                            Text("\(songVM.durationFormated(songVM.currentTime))")
                            Spacer()
                            Text("\(songVM.durationFormated(songVM.totalTime))")
                        }
                        .durationFont()
                        .padding(.bottom, 15)
                        
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
                        .padding(.bottom, 10)
                        
                        HStack(spacing: 40) {
                            CustomButton(image: "backward.end.fill", size: 30) {
                                songVM.backward()
                            }
                            .matchedGeometryEffect(id: "Backward", in: playerAnimation)
                            CustomButton(image: songVM.isPlaying ? "pause.circle.fill" : "play.circle.fill", size: 60) {
                                songVM.playPause()
                            }
                            .matchedGeometryEffect(id: "Play", in: playerAnimation)
                            CustomButton(image: "forward.end.fill", size: 30) {
                                songVM.forward()
                            }
                            .matchedGeometryEffect(id: "Forward", in: playerAnimation)
                        }
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        
                        HStack {
                            CustomButton(image: "repeat", size: 25) {
                                songVM.repeatSong()
                            }
                            .opacity(songVM.isRepeat ? 1 : 0.4)
                            
                            Spacer()
                            
                            CustomButton(image: "shuffle", size: 25) {
                                songVM.shuffleSongs()
                            }
                            .opacity(songVM.isShuffle ? 1 : 0.4)
                        }
                        .padding(.vertical, 30)
                        .padding()
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    private func CustomButton(image: String, size: CGFloat, action: @escaping ()->()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .resizable()
                .foregroundStyle(.white)
                .frame(width: size, height: size)
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
