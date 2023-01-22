//
//  VideoListResponse.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/19/23.
//

import Foundation

struct Video: Identifiable, Decodable {
    var id: String?
    var published: Date?
    var title: String?
    var description: String?
    var channelTitle: String?
    var tags: [String]?
    var categoryID: Int?
    var thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        // ordered by use
        case id
        case publishedAt
        case snippet
        case title
        case description
        case thumbnails
        case high
        case url
        case channelTitle
        case tags
        case categoryId
    }
    
    init(from decoder: Decoder) throws {
        // Video container -> "items: [{video1}, {video2}, {videoN... etc}]"
        let videoContainer = try decoder.container(keyedBy: CodingKeys.self)
        // The objects in video container are: kind, etag, id, snippet, contentDetails, statistics
        self.id = try videoContainer.decode(String.self, forKey: .id)
        // Snippet container -> "snippet: {publishedAt, channelID, etc}"
        let snippetContainer = try videoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        // The objects in snippet container are: publishedAt, channelId, title, description, thumbnails, channelTitle,
        // tags, categoryId, liveBroadcastContent, defaultLanguage, localized, defaultAudioLanguage
        self.published = try snippetContainer.decode(Date.self, forKey: .publishedAt)
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        // Thumbnails container ->
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        // The objects in thumbnails container are: default, medium, high, standard
        // THE Thumbnail container -> "high: {}"
        let thumbnailContainer = try thumbnailsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        //the objects in thumbnail container are: url, width, height
        self.thumbnailURL = try thumbnailContainer.decode(String.self, forKey: .url)
        self.tags = try snippetContainer.decode([String].self, forKey: .tags)
        //self.categoryID = try snippetContainer.decode(Int.self, forKey: .categoryId)
        print("Video title: \(self.title!)")
    }
    
    // extra init for preview
    init (title: String, channelTitle: String) {
        self.title = title
        self.channelTitle = channelTitle
    }
}

struct VideoListResponse: Decodable {
    var items: [Video] = []
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init (from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try mainContainer.decode([Video].self, forKey: .items)
        //print(items!)
    }
}

final class VideoListClass: ObservableObject {
    var videos: [Video] = []
    @Published var videoIDs: [String]
    
    func getInfo() {
        print("Response info!!")
        print(self.videos.count)
        print(self.videos.isEmpty)
    }
    
    func getVideoListResponse() {
        print("fetch was called")
        // check for video ids
        if (videoIDs.count == 0) {
            return
        }
        // initial setup
        print("videoIDs array has values")
        var API_URL_1 = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics"
        
        for element in videoIDs {
            API_URL_1 += "&id=\(element)"
        }
        API_URL_1 += "&key=\(Constants.API_KEY)"
        let API_URL = API_URL_1
        print("about to create a url object using \(API_URL)")
        
        // Create a URL object
        let url = URL(string: API_URL)
        guard url != nil else {
            return
        }
        print("created the url")
        // Get a URLSession object
        let session = URLSession.shared
        print("created the url session")
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
                let response = try decoder.decode(VideoListResponse.self, from: data!)
                print("after getting response")
                self.videos = response.items
//                DispatchQueue.main.async {
//                    print("was this run?")
//                    print(response.items.count)
//                    self.videos = response.items
//                    print(self.videos.count)
//                }
                self.getInfo()
                //dump(response)
            } catch {
                print(error)
            }
        }
        
        // Kick off the task
        dataTask.resume()
    }
    
    init() {
        videoIDs = []
    }
    
    init(videoIDs: [String]) {
        self.videoIDs = videoIDs
    }
    
}

extension VideoListClass {
    
    enum ListVideoError: LocalizedError {
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


