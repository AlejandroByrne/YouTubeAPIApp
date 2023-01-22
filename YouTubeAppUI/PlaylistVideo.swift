//
//  PlaylistVideo.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import Foundation

struct VideoFromPlaylist: Decodable {
    var videoID = ""
    var title = ""
    var description = ""
    var thumbnail = ""
    var published = Date()
    var channelTitle = ""
    
    enum CodingKeys: String, CodingKey {
        case snippet
        case thumbnails
        case high
        case resourceId
        
        case published = "publishedAt"
        case title // don't have to specify if the json key is same as variable name
        case channelTitle
        case description // ''
        case thumbnail = "url"
        case videoID = "videoId"
    }
    
    init(title: String, channelTitle: String) {
        self.title = title
        self.channelTitle = channelTitle
    }
    
    init (from decoder: Decoder) throws {
        // Parse video container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Parse snippet container
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        // Parse title
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        // Parse channel title
        self.channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        // Parse description
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        // Parse publish date
        self.published = try snippetContainer.decode(Date.self, forKey: .published)
        // Parse thumbnails container
        let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        // Parse high resolution thumbnail container
        let highContainer = try thumbnailContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        // Parse thumbnail
        self.thumbnail = try highContainer.decode(String.self, forKey: .thumbnail)
        // Parse resourceId container
        let resourceIdContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
        // Parse videoId
        self.videoID = try resourceIdContainer.decode(String.self, forKey: .videoID)
    }
}
