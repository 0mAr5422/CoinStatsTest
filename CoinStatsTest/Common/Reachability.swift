//
//  Reachability.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/26/22.
//

import Foundation


import Network
import UIKit
import Foundation

public class Reachability {
    
    var monitor : NWPathMonitor! = nil
    static let shared = Reachability()
    public private(set) var isConnected : Bool = false
    private init(){
        monitor = NWPathMonitor()
    }
    public func startMonitoring(window : UIWindow?) {
        
        var isAcPresented = false
        monitor.pathUpdateHandler = { path in
            
            let ac = UIAlertController(title: "no internet connection", message: "try reconnecting", preferredStyle: .actionSheet)
            let topController = window?.rootViewController
            
            if path.status == .satisfied {
                if isAcPresented == true {
                    topController?.dismiss(animated: true, completion: nil)
                    isAcPresented = false
                }
                
            } else {
                
                isAcPresented = true
                topController?.dismiss(animated: true, completion: nil)
                topController?.present(ac, animated: true, completion: nil)
               
            }

        }
        monitor.start(queue: DispatchQueue.main)
    }
   
    
}
