//
//  ServiceError.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


struct ServiceError : Error , Codable {
    let httpsStaus : Int
    let errorMessage : String
    
}
