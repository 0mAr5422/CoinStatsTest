//
//  FeedResponseModel.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation

enum ArticleReadStatus : String , Codable  {
    case new = "New"
    case read = "Read"
    
    
}

struct FeedResponseModel : Codable {
    let success : Bool
    let errors : [ServiceError]
    let data : [FeedArticle]
    
    enum CodingKeys : String, CodingKey {
        case success
        case errors
        case data
    }
}

struct FeedArticle : Codable , Hashable {

    let identifier = UUID()

    let category : String
    let title : String
    let body : String
    let shareURL : String
    let coverPhotoURL : String
    let date : Double
    let imagesGallery : [GalleryItem]?
    let videoGallery : [VideoItem]?
    
    enum CodingKeys : String , CodingKey {
//        case _status
        case category
        case title
        case body
        case shareURL = "shareUrl"
        case coverPhotoURL = "coverPhotoUrl"
        case date
        case imagesGallery = "gallery"
        case videoGallery = "video"
    }

}




