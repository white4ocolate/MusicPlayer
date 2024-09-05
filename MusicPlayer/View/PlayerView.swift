//
//  ContentView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 02.09.2024.
//

import SwiftUI

struct PlayerView: View {
    
    //MARK: - Properties
    @StateObject var songVM: SongViewModel = SongViewModel()
    @State private var isShowFiles: Bool = false
    @State private var isShowFullPlayer: Bool = false
    @Namespace private var playerAnimation
    
    var playButtonImage: String {
        return songVM.isPlaying ? "pause.fill" : "play.fill"
    }
    var frameImage: CGFloat {
        isShowFullPlayer ? 240 : 20
    }
    var frameBackground: CGFloat {
        isShowFullPlayer ? 320 : 40
    }
    
    //MARK: - View
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                ZStack {
                    //MARK: - List of songs
                    List {
                        ForEach(songVM.songs) { song in
                            SongView(song: song, durationFormated: songVM.durationFormated)
                                .onTapGesture {
                                    if songVM.currentSong != song {
                                        songVM.playAudio(song: song)
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .foregroundStyle(.white)
                    .safeAreaInset(edge: .bottom) {
                        
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
                ImportFileManager(songs: $songVM.songs)
                    .ignoresSafeArea()
            })
        }
    }
    
    //MARK: - Methods
    private func Player() -> some View {
        VStack {
            //MARK: - Mini player
            HStack {
                if let data = songVM.currentSong?.coverImage, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: frameBackground, height: frameBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                } else {
                    ZStack{
                        Color.purple
                            .frame(width: frameBackground, height: frameBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: frameImage, height: frameImage)
                    }
                }
                if !isShowFullPlayer {
                    VStack(alignment: .leading) {
                        SongDescription()
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    Spacer()
                    
                    CustomButton(image: playButtonImage, size: .title) {
                        songVM.playPause()
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
                    .padding(.top)
                    
                    VStack {
                        /// Duration
                        HStack {
                            Text("00:00")
                            Spacer()
                            Text("03:21")
                        }
                        .durationFont()
                        .padding()
                        
                        ///Slider
                        Divider()
                        
                        HStack(spacing: 40) {
                            CustomButton(image: "backward.end.fill", size: .title2) {
                                
                            }
                            CustomButton(image: playButtonImage, size: .largeTitle) {
                                songVM.playPause()
                            }
                            CustomButton(image: "forward.end.fill", size: .title2) {
                                
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
