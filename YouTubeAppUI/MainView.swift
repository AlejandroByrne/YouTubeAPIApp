//
//  MainView.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CategoryView()
                .tabItem() {
                    Image(systemName: "person.fill")
                    Text("Browse")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
