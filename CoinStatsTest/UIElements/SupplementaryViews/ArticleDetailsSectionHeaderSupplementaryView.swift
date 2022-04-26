//
//  ArticleDetailsSectionHeaderSupplementaryView.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit


enum ViewAll : String {
    case article
    case images
    case videos
}
protocol ArticleDetailsSectionHeaderItemDelegate : AnyObject {
    func handleViewAllAction(type : ViewAll)
}

final class ArticleDetailsSectionHeaderItem : UICollectionReusableView {
    static let reuseIdentifier = "article-details-section-header-item-reuse-identifier"
    private var viewAllButton : UIButton! = nil
    private var sectionTitleLabel : UILabel! = nil
    public weak var delegate : ArticleDetailsSectionHeaderItemDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureViewAllButton()
        configureSectionTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initialize SectionHeaderSupplementaryView")
    }
    @objc private func handleButtonAction(_ sender : UIButton){
        switch sectionTitleLabel.text {
        case "Article":
            delegate?.handleViewAllAction(type: .article)
        case "Gallery" :
            delegate?.handleViewAllAction(type: .images)
        case "Videos" :
            delegate?.handleViewAllAction(type: .videos)
        default :
            break
        }

    }
}

extension ArticleDetailsSectionHeaderItem {
    public func setupHeader(title : String , buttonTitle : String) {
        sectionTitleLabel.text = title
        viewAllButton.setTitle(buttonTitle, for: .normal)
        
    }
    
    private func configureViewAllButton() {
        viewAllButton = UIButton(type: .system)
        
        viewAllButton.setTitleColor(.black, for: .normal)
        viewAllButton.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
        addSubview(viewAllButton)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            viewAllButton.topAnchor.constraint(equalTo: topAnchor, constant: 5 ),
            viewAllButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            viewAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            viewAllButton.widthAnchor.constraint(equalToConstant: 77)
            
        ])
        
        
    }
    
    private func configureSectionTitleLabel() {
        sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionTitleLabel)
        NSLayoutConstraint.activate([
            
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5 ),
            sectionTitleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
            
        ])
        sectionTitleLabel.textColor = .black
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
