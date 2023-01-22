//
//  ContentView.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //private var videoIDs: [String]
    @ObservedObject private var vm = VideoListClass()
    
    init (videoIDs: [String]) {
        vm.videoIDs = videoIDs
        vm.getVideoListResponse()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(vm.videos, id: \.id) { video in
                        VideoView(video: video)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Videos: \(vm.videos.count)")
            }
        }
    }
    
    init () {
        vm.videoIDs = ["ezSpDRAnOV0", "xy3AcmW0lrQ"]
        vm.getVideoListResponse()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
