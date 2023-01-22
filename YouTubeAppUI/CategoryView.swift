//
//  CategoryView.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import SwiftUI

struct CategoryView: View {
    var thumbs: [[String]] = [
        ["Gym Motivation",
            "https://i.ytimg.com/vi/O640yAgq5f8/hqdefault.jpg"],
        ["Study Motivation",
            "https://i.ytimg.com/vi/KPlJcD-o-4Q/hqdefault.jpg"],
        ["Philosophy/Ethics",
            "https://i.ytimg.com/vi/__RAXBLt1iM/hqdefault.jpg"],
        ["Podcast Clips",
            "https://i.ytimg.com/vi/-wIt_WsJGfw/hqdefault.jpg"]]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    ForEach(thumbs, id: \.self) { thumb in
                        ZStack {
                            CategoryTileView(title: thumb[0], url: thumb[1])
                                .padding(20)
                        }
                    }
                }
            }
            .navigationTitle("Grid sample")
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
