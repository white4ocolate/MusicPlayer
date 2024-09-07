//
//  SongImageView.swift
//  MusicPlayer
//
//  Created by white4ocolate on 06.09.2024.
//

import SwiftUI

struct SongImageView: View {
    
    //MARK: - Properties
    let imageData: Data?
    let size: CGFloat
    
    //MARK: - View
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            ZStack{
                Color.purple
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Image(systemName: "music.note")
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
    }
}

#Preview {
    SongImageView(imageData: Data(), size: 200)
}
