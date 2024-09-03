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
    @State private var showFullPlayer: Bool = true
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 20
    }
    var frameBackground: CGFloat {
        showFullPlayer ? 320 : 40
    }
    
    //MARK: - View
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    //MARK: - List of songs
                    List {
                        ForEach(songVM.songs) { song in
                            SongView(song: song, durationFormated: songVM.durationFormated)
                                .onTapGesture {
                                    songVM.playAudio(song: song)
                                }
                        }
                    }
                    .listStyle(.plain)
                    Spacer()
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
                            
                            if !showFullPlayer {
                                VStack(alignment: .leading) {
                                    Text("track #1")
                                        .font(.title3)
                                    Text("unknown")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .foregroundStyle(.white)
                                        .frame(width: 25, height: 25)
                                })
                            }
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding()
                        
                        //MARK: - Full player
                        if showFullPlayer {
                            
                            /// Description
                            VStack {
                                Text("track #1")
                                    .font(.title3)
                                Text("unknown")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.white)
                            
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
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        Image(systemName: "backward.end.fill")
                                    })
                                    Button(action: {}, label: {
                                        Image(systemName: "play.fill")
                                    })
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        Image(systemName: "forward.end.fill")
                                    })
                                }
                                .foregroundStyle(.white)
                            }
                        }
                        
                    }
                    .onTapGesture {
                        withAnimation(.spring) {
                            self.showFullPlayer.toggle()
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
            })
        }
    }
}

#Preview {
    PlayerView()
}
