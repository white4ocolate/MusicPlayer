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
    @State private var isShowFullPlayer: Bool = true
    //    @State var song: SongModel = SongModel(trackName: "test1", data: Data())
    @Namespace private var playerAnimation
    
    
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
                                    songVM.playAudio(song: song)
                                }
                        }
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                        //                        SongView(song: song)
                    }
                    .listStyle(.plain)
                    .foregroundStyle(.white)
                    .safeAreaInset(edge: .bottom) {
                        
                        //MARK: - Player
                        VStack {
                            
                            //MARK: - Mini player
                            HStack {
                                ZStack {
                                    Color.purple
                                        .frame(width: frameBackground, height: frameBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    Image(systemName: "music.note")
                                        .resizable()
                                        .frame(width: frameImage, height: frameImage)
                                }
                                
                                if !isShowFullPlayer {
                                    VStack(alignment: .leading) {
                                        Text("track #1")
                                            .font(.title3)
                                        Text("unknown")
                                            .font(.subheadline)
                                    }
                                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                                    
                                    Spacer()
                                    
                                    CustomButton(image: "play.fill", size: .title) {
                                        
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
                                        Text("track #1")
                                            .font(.title3)
                                        Text("unknown")
                                            .font(.subheadline)
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
                                            CustomButton(image: "play.fill", size: .largeTitle) {
                                                
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
                        .frame(height: isShowFullPlayer ? SizeConstants.fullPlayer : SizeConstants.miniPlayer)
                        .onTapGesture {
                            withAnimation(.spring) {
                                self.isShowFullPlayer.toggle()
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
    private func CustomButton(image: String, size: Font, action: @escaping ()->()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .foregroundStyle(.white)
                .font(size)
        })
    }
}

#Preview {
    PlayerView()
}
