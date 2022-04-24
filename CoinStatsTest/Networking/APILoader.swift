//
//  APILoader.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


struct APILoader<T : APIHandler> {
    var apiHandler : T
    var urlSession : URLSession
    
    init(apiHandler : T , urlSession : URLSession = .shared){
        self.apiHandler = apiHandler
        self.urlSession = urlSession
    }
    
    func performAPIRequest(requestData : T.RequestDataType , completionHandler : @escaping (T.ResponseDataType? , ServiceError?) -> ()) {
        if let urlRequest = apiHandler.makeRequest(from: requestData){
            urlSession.dataTask(with: urlRequest) { data, response, err in
                if let response = response as? HTTPURLResponse {
                    if let err = err {
                        completionHandler(nil, ServiceError(httpsStatus: response.statusCode, errorMessage: err.localizedDescription))
                        return
                    }
                    guard let data = data else {
                        completionHandler(nil , ServiceError(httpsStatus: response.statusCode, errorMessage: "data came back as nil"))
                        return
                    }
                    do {
                        let decodedResponse = try apiHandler.parseResponse(data: data, response: response)
                        completionHandler(decodedResponse , nil)
                        return
                    }
                    catch let err {
                        completionHandler(nil , ServiceError(httpsStatus: response.statusCode, errorMessage: "Failed to decode data , Error : \(err.localizedDescription)"))
                        return
                    }
                }
            }.resume()
        }
    }
}
