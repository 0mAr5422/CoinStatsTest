//
//  VideoItem.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation

struct VideoItem : Codable {
    let title : String
    let thumbnailURL : String
    let youtubeID : String
    
    enum CodingKeys : String , CodingKey {
        case title
        case thumbnailURL = "thumbnailUrl"
        case youtubeID = "youtubeId"
    }
}
