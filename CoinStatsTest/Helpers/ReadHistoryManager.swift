//
//  ReadHistoryManager.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/26/22.
//

import Foundation

final class ReadHistoryManager {
    private init(){}
    static let shared = ReadHistoryManager()
    private var keyForReadArticles = "read-articles-user-defaults-key"
    
    // checks if the article's shareURL is present in the userDefaults collection
    func isRead(articleShareURL : String) -> Bool {
        guard let readArticles = UserDefaults.standard.object(forKey: ReadHistoryManager.shared.keyForReadArticles) as? [String] else {
            return false
        }
        
        return readArticles.contains(articleShareURL)
    }
    
    // adds article to the list of read articles in userdefaults
    // if there is not userdefaults object for the key we create a new one
    func markArticleAsRead(articleShareURL : String){
        
        guard var readArticles = UserDefaults.standard.object(forKey: ReadHistoryManager.shared.keyForReadArticles) as? [String] else {
            let newSet = [articleShareURL]
            
            UserDefaults.standard.set(newSet, forKey: ReadHistoryManager.shared.keyForReadArticles)
            return
        }
        
        readArticles.append(articleShareURL)
        let s = Set(readArticles)
        readArticles = Array(s)
        UserDefaults.standard.set(readArticles, forKey: ReadHistoryManager.shared.keyForReadArticles)
        
    }
    
    // deletes history
    // ** marks all articles as new **//
    func deleteHistory(){
        
        UserDefaults.standard.set(nil, forKey: ReadHistoryManager.shared.keyForReadArticles)
        
    }
    
    
}
