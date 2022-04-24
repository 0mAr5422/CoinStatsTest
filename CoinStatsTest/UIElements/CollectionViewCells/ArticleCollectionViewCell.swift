//
//  ArticleCollectionViewCell.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import UIKit

final class ArticleCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "article-collection-view-cell-reuse-identifier"
    
    private var imageView : UIImageView! = nil
    private var titleLabel : UILabel! = nil
    private var categoryLabel : UILabel! = nil
    private var dateLabel : UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initalize coder for cell with identifier \(ArticleCollectionViewCell.reuseIdentifier)")
    }
    
}

//MARK: UI Configuration

extension ArticleCollectionViewCell {
        
    public func setupCell(with article : FeedArticle) {
        self.titleLabel.text = article.title
        self.categoryLabel.text = article.category
        self.dateLabel.text = "Released : \(Date(timeIntervalSince1970: article.date))"
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else {return}
            self.imageView.setImageFromDownloadURL(from: article.coverPhotoURL)
        }
        
        
        
    }
    
    private func configureContentView(){
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.systemGray4.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds , cornerRadius: 10).cgPath
        configureImageView()
        configureTitleLabel()
        configureDateLabel()
        configureCategoryLabel()
    }
    
    private func configureImageView(){
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor) ,
            imageView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
            
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.addActivityIndicator()
        
        
    }
    private func configureTitleLabel(){
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor , constant: 0) ,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 5),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
            
        ])
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        titleLabel.numberOfLines = 0
        
    }
    
    private func configureDateLabel(){
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1)
            
        ])
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        
        dateLabel.clipsToBounds = true
        
    

    }
    
    private func configureCategoryLabel(){
        categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -5) ,
            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            categoryLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
            
        ])
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        categoryLabel.backgroundColor = .systemGray6
        categoryLabel.clipsToBounds = true
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            self.categoryLabel.layer.cornerRadius = self.categoryLabel.frame.height / 2
            
        }
    }
    
}
