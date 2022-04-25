//
//  TextHolderCollectionViewCell.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit

final class TextHolderCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "text-holder-collection-view-cell-reuse-identifier"
    private var textView : UITextView! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initialize coder for collectionViewCell with identifier : \(TextHolderCollectionViewCell.reuseIdentifier)")
    }
    
}
//MARK: UI Configuration

extension TextHolderCollectionViewCell {
    public func setupCell(with text : String , font : UIFont ) {
        textView.text = text
        textView.font = font
    }
    private func configureContentView(){
        configureTextView()
    }
    private func configureTextView(){
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 0),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 0),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.font = UIFont.boldSystemFont(ofSize: 22)
        textView.textColor = .black
        
        textView.isEditable = false
        textView.backgroundColor = .clear
        
    }
    
}
