//
//  ReadFullArticleViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/25/22.
//

import UIKit


final class ReadFullArticleViewController : UIViewController {
    
    private var textView : UITextView! = nil
    private var text : String!
    init(with text : String) {
        self.text = text;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initalize coder for ReadFullArticleViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView = UITextView(frame: view.bounds)
        textView.center = view.center
        textView.textColor = .black
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 26)
        textView.text = self.text
        view.addSubview(textView)
        
    }
}
