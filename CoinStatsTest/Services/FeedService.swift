//
//  FeedService.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


struct FeedService : APIHandler {
   
   
    func makeRequest(from params: KeyValuePairs<String,Any>) -> URLRequest? {
        let feedURL = APIPath.feedAPIPath
        // safely creating URL from String
        guard let url = URL(string: feedURL) else {return nil}
        
        guard let finalURL = setParams(params: params, url: url) else {return nil}
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = HTTPMethods.get.rawValue
        
        return request
    }
    
    func parseResponse(data: Data, response: HTTPURLResponse) throws -> FeedResponseModel {
        try defaultResponse(data: data, response: response)
    }
    
    
}
