//
//  ResponseHandler+Extensions.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


extension ResponseHandler {
    
    
    func defaultResponse<T:Codable>(data : Data , response : HTTPURLResponse) throws -> T {
        let jsonDecoder = JSONDecoder()
        do {
            let body = try jsonDecoder.decode(T.self, from: data)
            if response.statusCode == 200 {
                return body
            }
            else {
                let serviceErr = ServiceError(httpsStatus: response.statusCode, errorMessage: "response code not 200")
                print(serviceErr , "In defaultResponse - ResponseHandler+Extensions")
                throw serviceErr
                
            }
        }
        catch let err {
            let serviceErr = ServiceError(httpsStatus: response.statusCode, errorMessage: "Error with decoding , Error Message : \(err)")
            print(serviceErr , "In defaultResponse - ResponseHandler+Extensions")
            throw serviceErr
        }
    }
    
    
}
