//
//  ServiceError.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


struct ServiceError : Error , Codable {
    let httpsStatus : Int
    let errorMessage : String
    
    enum CodingKeys : String , CodingKey {
        case httpsStatus
        case errorMessage
    }
    
}
