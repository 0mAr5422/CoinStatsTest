//
//  RequestHandler+Extensions.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


extension RequestHandler {
    func setParams(params : KeyValuePairs<String , Any> , url : URL) -> URL? {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = params.map{parameter in URLQueryItem(name: parameter.key, value: String(describing:parameter.value))}
        
        guard let finalUrl = urlComponents?.url else {return nil}
        return finalUrl
        
    }
}
