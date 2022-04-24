//
//  FeedViewModel.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import Foundation


final class FeedViewModel {
    
    public var isLoading : Bool = false
    
    
    public func performDataFetch(with params : KeyValuePairs<String , Any> , completion : @escaping ([FeedArticle] , ServiceError?) -> ()) {
        
        var results : [FeedArticle] = []
        var serviceErr : ServiceError?
        let dispatchGroup = DispatchGroup()
        isLoading = true
        dispatchGroup.enter()
        
        fetchData(with: params) { model, err in
            
            
            if let _ = err {
                serviceErr = err
                
            }
            else {
                guard let data = model?.data else {return}
                results = data
                self.isLoading = false
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            completion(results , serviceErr)
        }
        
    }
    
    
    private func fetchData(with params : KeyValuePairs<String , Any> , completion : @escaping (FeedResponseModel? , ServiceError?) -> ()) {
        
        let request = FeedService()
        let loader = APILoader(apiHandler: request)
        
        loader.performAPIRequest(requestData: params) { model, err in
            // there was an error with getting the data or decoding it
            if let _ = err {
                completion(nil , err)
                return
            }
            else {
                // we were able to get the data from the server and decode it
                completion(model , nil)
                return
            }
            
        }
        
    }
}
