//
//  CoverImageCollectionViewCell.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit

final class CoverImageCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "cover-image-collection-view-cell-reuse-identifier"
    private var imageView : UIImageView! = nil
    private var categoryLabel : UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initialize coder for cell with reuse identifier : \(CoverImageCollectionViewCell.reuseIdentifier)")
    }
}

//MARK: UI Configuration
extension CoverImageCollectionViewCell {
    public func setupCell(coverURL : String , category : String) {
        imageView.image = nil
        imageView.setImageFromDownloadURL(from: coverURL)
        
        
        categoryLabel.text = category
        
    }
    
    private func configureImageView(){
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor) ,
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 15),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
            
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        
        
    }
    
    private func configureCategoryLabel(){
        categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            categoryLabel.topAnchor.constraint(equalTo: imageView.topAnchor , constant: 5) ,
            categoryLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            categoryLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor , multiplier: 0.2)
            
        ])
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 14)
        categoryLabel.backgroundColor = .systemGray6
        categoryLabel.clipsToBounds = true
        categoryLabel.numberOfLines = 0
        categoryLabel.layer.cornerRadius = 5
    }
}
