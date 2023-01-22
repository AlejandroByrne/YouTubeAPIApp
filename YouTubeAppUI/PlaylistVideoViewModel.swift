//
//  PlaylistVideoViewModel.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import Foundation

final class PlaylistVideoViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    @Published var playlistTitle: String = ""
    @Published var hasError = false
    @Published var error: PlaylistVideoError?
    
    func fetchPlaylistList() {
        print("fetch was called")
        
        hasError = false
        let PLAYLIST_ID = "PLPNW_gerXa4Pc8S2qoUQc5e8Ir97RLuVW"
        let API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(PLAYLIST_ID)&key=\(Constants.API_KEY)"
        // Create a URL object
        let url = URL(string: API_URL)

        guard url != nil else {
            return
        }
        
        // Get a URLSession object
        let session = URLSession.shared
        
        // Get a date task from the URLSession object
        let dataTask = session.dataTask(with: url!) {
            (data, response, error) in
            
            // Check if there were any errors
            if error != nil || data == nil {
                return
            }
            
            do {
                // Parse data from the JSON file into video objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                print("before getting response")
                let response = try decoder.decode(PlaylistResponse.self, from: data!)
                print("after getting response")
                DispatchQueue.main.async {
                    self.videos = response.items!
                    self.playlistTitle = self.videos[0].channelTitle!
                }
                dump(response)
            } catch {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = PlaylistVideoError.failedToDecode
                }
            }
        }
        
        // Kick off the task
        dataTask.resume()
    }
}

extension PlaylistVideoViewModel {
    enum PlaylistVideoError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Failed to decode response"
            case .custom(let error):
                return error.localizedDescription
            }
        }
    }
}
