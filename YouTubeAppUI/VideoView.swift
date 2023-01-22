//
//  VideoView.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import SwiftUI

struct VideoView: View {
    
    let video: Video
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: video.thumbnailURL!)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 325, height: 182)
            Text("**Title**: \(video.title!)")
            Divider()
            Text("**Channel**: \(video.channelTitle!)")
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 4)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: .init(title: "Runner", channelTitle: "Djo"))
    }
}
