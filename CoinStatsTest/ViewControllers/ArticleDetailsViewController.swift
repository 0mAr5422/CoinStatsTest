//
//  ArticleDetailsViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit

private enum ArticleDetailsSections :  Hashable{
  
    
    case coverImage
    case title(dateString:String)
    case body
    case gallery
    case videos
    
    
}

final class ArticleDetailsViewController : UIViewController {
    
    private var collectionView : UICollectionView! = nil
    // since we have multiple sections we will use AnyHashable for the items
    // that menas that only items that conform to Hashable can be used
    // we will be able to case the item to the type that best fits the section
    // example :
    //      guard let item = itemIdentifier as? FeedArticle else {return}
    private var dataSource : DDataSource<ArticleDetailsSections , AnyHashable>! = nil
    private var barButtonItem : UIBarButtonItem! = nil
    private var article : FeedArticle?{
        didSet  {
            updateViewController()
        }
    }
      
    
    
    // custome type to hold value for out datasource items
    struct HashableTupleString : Hashable {
        let identifier = UUID()
        let first : String
        let second : String
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        configureDataSource()
        configureBarButtonItem()
        
        
    }
    func updateViewController(){
        guard let article = article else {
            return
        }

        if let _ = barButtonItem {
            barButtonItem.title = article.shareURL
        }
        var snap = NSDiffableDataSourceSnapshot<ArticleDetailsSections , AnyHashable>()
        let titleSection = ArticleDetailsSections.title(dateString: Date().getStringDateFromTimestamp(from: article.date))
        snap.appendSections([.coverImage , titleSection])
        snap.appendItems([
            HashableTupleString(first: article.coverPhotoURL, second: article.category)
        ], toSection: .coverImage)
        
        
        snap.appendItems([
            HashableTupleString(first: article.title, second: Date().getStringDateFromTimestamp(from: article.date))
        ], toSection: titleSection)
        
        // if article doesn't have a body no body section will be added
        if article.body != "" {
            snap.appendSections([.body])
            snap.appendItems([
                article.body
            ], toSection: .body)
        }
        // if article doesn't have any images no images section will be added
        if article.imagesGallery?.isEmpty == false {
            snap.appendSections([.gallery])
            snap.appendItems(article.imagesGallery ?? [], toSection: .gallery)
        }
        // if article doesn't have any videos no videos section will be added
        if article.videoGallery?.isEmpty == false {
            snap.appendSections([.videos])
            snap.appendItems(article.videoGallery ?? [], toSection: .videos)
        }

        
        if let _ = dataSource {
            dataSource.apply(snap,animatingDifferences: true)
        }
    }
    
    
   
    
    @objc private func handleRightBarButtonAction(_ sender : UIBarButtonItem){
        UIPasteboard.general.string = sender.title
        let alertAction = UIAlertController(title: "Copied", message: "share link copied", preferredStyle: .alert)
        // makr the alrtAction disappear after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            
            alertAction.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.present(alertAction, animated: true, completion: nil)
       
        
    }
    
}




// MARK: ArticlesFeedViewControllerDelegate Methods
extension ArticleDetailsViewController : ArticlesFeedViewControllerDelegate {
    func handleArticleSelection(with article: FeedArticle) {
        self.article = article
    }
    
    
}

//MARK: UI Configuration
extension ArticleDetailsViewController {
    
    private func configureBarButtonItem() {
        barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.on.square"), style: .plain, target: self, action: #selector(handleRightBarButtonAction(_:)))
        
        barButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, environment in
            guard let self = self else {return nil}
            var itemSize : NSCollectionLayoutSize! = nil
            var groupSize : NSCollectionLayoutSize! = nil
            
        
            switch sectionIndex {
            case 0 :
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
            case 1 :
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            case 2 :
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
            case 3 , 4 :
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(self.windowInterfaceOrientation?.isPortrait ?? true ? 0.2 : 0.4))
            default :
                break
            }
            
            // self.windowInterfaceOrientation is a computed property added to an extension to UIViewController in Helpers/Extensions
            
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(22))
            let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 10)
            switch sectionIndex {
            case 0 :
                break
            case 1 :
                section.boundarySupplementaryItems = [headerSupplementary]
                break
            case 2 :
                section.boundarySupplementaryItems = [headerSupplementary]
                break
            case 3 , 4 :
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerSupplementary]
                break
            default :
                break
            }
            
            return section
        }
        return layout
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout())
        view.addSubview(collectionView)
        collectionView.delaysContentTouches = false
        collectionView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.register(TextHolderCollectionViewCell.self, forCellWithReuseIdentifier: TextHolderCollectionViewCell.reuseIdentifier)
        collectionView.register(CoverImageCollectionViewCell.self, forCellWithReuseIdentifier: CoverImageCollectionViewCell.reuseIdentifier)
        collectionView.register(GalleryAndVideoItemCollectionViewCell.self, forCellWithReuseIdentifier: GalleryAndVideoItemCollectionViewCell.reuseIdentifier)
        collectionView.register(ArticleDetailsSectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArticleDetailsSectionHeaderSupplementaryView.reuseIdentifier)
    }
    
    private func configureDataSource(){
        
        dataSource = DDataSource
            <ArticleDetailsSections, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in

                

                switch indexPath.section {
                case 0 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverImageCollectionViewCell.reuseIdentifier, for: indexPath) as? CoverImageCollectionViewCell else {return nil}
                    guard let item = item as? HashableTupleString else {return nil}
                    cell.setupCell(coverURL: item.first, category: item.second)
                    return cell
                case 1  :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHolderCollectionViewCell.reuseIdentifier, for: indexPath) as? TextHolderCollectionViewCell else {return nil}
                    
                    guard let item = item as? HashableTupleString else {return nil}
                    cell.setupCell(body: item.first , font: UIFont.boldSystemFont(ofSize: 24) )
                    return cell
                case 2 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHolderCollectionViewCell.reuseIdentifier, for: indexPath) as? TextHolderCollectionViewCell else {return nil}
                    
                    guard let item = item as? String else {return nil}
                    cell.setupCell(body: item , font:  UIFont.systemFont(ofSize: 16) )
                    return cell
                case 3 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryAndVideoItemCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryAndVideoItemCollectionViewCell else {return nil}
                    guard let item = item as? GalleryItem else {return nil}
                    cell.setupCellWith(galleryItem: item)
                    return cell
                case 4 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryAndVideoItemCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryAndVideoItemCollectionViewCell else {return nil}
                    guard let item = item as? VideoItem else {return nil}
                    cell.setupCell(with: item)
                    return cell
                    
                default:
                    return nil
                }
        }
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            guard let self = self else {return nil}
            guard let headerItem = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArticleDetailsSectionHeaderSupplementaryView.reuseIdentifier, for: index) as? ArticleDetailsSectionHeaderSupplementaryView else {return nil}
            // we set ourself as headerItem.delegate to ensure we control what happens when view all button from ArticleSectionHeaderSupplementaryView gets tapped
            headerItem.delegate = self
            
            switch index.section {
            case 0 :
                return nil
            case 1 :
                
                guard let item = self.dataSource.itemIdentifier(for: index) as? HashableTupleString else {return nil}
                headerItem.setupHeader(title: item.second , buttonTitle: "")
                
                return headerItem
            case 2 :
                headerItem.setupHeader(title: "Article" , buttonTitle: "Read More")
                return headerItem
            
            case 3 :
                headerItem.setupHeader(title: "Gallery" , buttonTitle: "View All")
                return headerItem
            case 4 :
                headerItem.setupHeader(title: "Videos" , buttonTitle: "View All")
                return headerItem
            default:
                return nil
            }
            
            
        }
        
        
        
    }
    
}
extension ArticleDetailsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }

    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = .identity
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            guard let item = dataSource.itemIdentifier(for: indexPath) as? GalleryItem else {return}
            let vc = ImageAndVideoViewController(with: item.contentURl, videoURL: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 4 {
            guard let item = dataSource.itemIdentifier(for: indexPath) as? VideoItem else {return}
            // video doesn't want to play in embeded
            // maybe because video is old
            let vc = ImageAndVideoViewController(with: nil , videoURL: "https://www.youtube.com/embed/" + item.youtubeID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// this extension contains the required ArticleDetailsSectionHeaderItemDelegate Methods

extension ArticleDetailsViewController : ArticleDetailsSectionHeaderSupplementaryViewDelegate {
    
    
    
    
    // this method allows us to control what will happen when the view more button is tapped
    // the section where this button will be called will determin what we will show
    // if tapped in the article body section it will show a viewcontroller with the article body
    // if tapped in the gallery or videos section it will show a viewcontroller that has a collectionview and gallery or video elements
    // inside it
    func handleViewAllAction(type: ViewAll) {
        switch type {
        case .videos :
            let vc = GalleryAndVideoViewController(with: nil, videoItem: self.article?.videoGallery)
            navigationController?.pushViewController(vc, animated: true)
        
        case .images :
            let vc = GalleryAndVideoViewController(with: self.article?.imagesGallery, videoItem: nil)
            navigationController?.pushViewController(vc, animated: true)
        case .article :
            let vc = ReadFullArticleViewController(with: self.article?.body ?? "")
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
