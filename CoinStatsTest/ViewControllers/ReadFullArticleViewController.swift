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
        view.backgroundColor = .white
        configureTextView()
        
        
    }
}

//MARK: UI Configuration
extension ReadFullArticleViewController {
    private func configureTextView() {
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: 0)
        ])
        textView.textColor = .black
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 26)
        textView.text = self.text
    }
}
