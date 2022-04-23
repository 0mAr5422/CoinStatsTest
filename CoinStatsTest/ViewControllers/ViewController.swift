//
//  ViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let feedViewModel = FeedViewModel()
        view.backgroundColor = .blue
        DispatchQueue.global(qos: .userInitiated).async {
            
            feedViewModel.performDataFetch(with: [:]) { model, err in
            if let _ = err {
                print(err)
                return
            }
            else {
                print(model)
            }
            }
        }
        
    }


}

