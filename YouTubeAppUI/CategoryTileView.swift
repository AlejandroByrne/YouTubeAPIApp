//
//  CategoryTileView.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import SwiftUI

struct CategoryTileView: View {
    
    let title: String
    let imageURL: URL
    
    init(title: String, url: String) {
        self.title = title
        self.imageURL = URL(string: url)!
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            Color.black
                .opacity(0.5)
            Text(title)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
                .bold()
        }
        .frame(width: 200, height: 200)
        .cornerRadius(20)
    }
}

struct CategoryTileView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTileView(title: "Test Title", url: "https://i.ytimg.com/vi/-wIt_WsJGfw/hqdefault.jpg")
    }
}
