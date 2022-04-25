//
//  GalleryItemCollectionViewCell.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit

final class GalleryAndVideoItemCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "gallery-item-collection-view-cell-reuse-identifier"
    
    private var imageView : UIImageView! = nil;
    private var nameLabel : UILabel! = nil;
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initialize coder for cell with reuse identifier : \(GalleryAndVideoItemCollectionViewCell.reuseIdentifier)")
    }
    
}
extension GalleryAndVideoItemCollectionViewCell {
    
    public func setupCell(with videoItem : VideoItem) {
        nameLabel.text = videoItem.title
        imageView.setImageFromDownloadURL(from: videoItem.thumbnailURL)
    }
    public func setupCellWith(galleryItem : GalleryItem) {
        nameLabel.text = galleryItem.title
        imageView.setImageFromDownloadURL(from: galleryItem.thumbnailURL)
        
        
    }
    
    
    private func configureImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0 ),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        
        ])
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.addActivityIndicator()
      
    }
    private func configureNameLabel(){
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0 ),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        
        ])
        
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 26)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        
    }
    
}
