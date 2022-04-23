//
//  GalleryItem.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation

struct GalleryItem : Codable {
    let title : String
    let thumbnailURL : String
    let contentURl : String
    
    enum CodingKeys : String , CodingKey {
        case title
        case thumbnailURL = "thumbnailUrl"
        case contentURl = "contentUrl"
    }
}
