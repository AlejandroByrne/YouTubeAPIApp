//
//  PlaylistResponse.swift
//  YouTubeAppUI
//
//  Created by Alejandro Byrne on 1/12/23.
//

import Foundation

struct PlaylistResponse: Decodable {
    
    var items: [Video]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([Video].self, forKey: .items)
    }
}
