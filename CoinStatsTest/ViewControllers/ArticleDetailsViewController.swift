//
//  ArticleDetailsViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/24/22.
//

import UIKit

private enum ArticleDetailsSections : String , CaseIterable {
    case coverImage
    case title
    case body
    case gallery
    case videos
    
}

final class ArticleDetailsViewController : UIViewController {
    
    private var collectionView : UICollectionView! = nil
    private var dataSource : DDataSource<ArticleDetailsSections , AnyHashable>! = nil
    private var article : FeedArticle!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
   
        
    }
    
   
    
    @objc private func handleRightBarButtonAction(_ sender : UIBarButtonItem){
        UIPasteboard.general.string = sender.title
        let alertAction = UIAlertController(title: "Copied", message: "share link copied", preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            alertAction.dismiss(animated: true, completion: nil)
        }
        present(alertAction, animated: true, completion: nil)
    }
    
}


// this extension contains the configureViewController Method that gets called from RootSplitViewController to initialize this view
extension ArticleDetailsViewController {
    public func configureViewController(){
        
        configureCollectionView()
        configureDataSource()

    }
}


extension ArticleDetailsViewController : ArticlesFeedViewControllerDelegate {
    func handleArticleSelection(with article: FeedArticle) {
        
        self.article = article
        
        // will create a bar button that has only an image and set it's title to the share url so it can be accessed in the Selector
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(handleRightBarButtonAction(_:)))
        button.title = article.shareURL
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
        
        var snap = NSDiffableDataSourceSnapshot<ArticleDetailsSections , AnyHashable>()
        snap.appendSections([.coverImage , .title])
        snap.appendItems([
            [article.coverPhotoURL , article.category]
        ], toSection: .coverImage)
        snap.appendItems([
            article.title
        ], toSection: .title)
        if article.body != "" {
            snap.appendSections([.body])
            snap.appendItems([
                article.body
            ], toSection: .body)
        }
        if article.imagesGallery?.isEmpty == false {
            snap.appendSections([.gallery])
            snap.appendItems(article.imagesGallery ?? [], toSection: .gallery)
        }
        
        if article.videoGallery?.isEmpty == false {
            snap.appendSections([.videos])
            snap.appendItems(article.videoGallery ?? [], toSection: .videos)
        }
        
        
        
        dataSource.apply(snap)
        
    }
    
    
}

extension ArticleDetailsViewController {
    
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, environment in
            
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
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(self?.windowInterfaceOrientation?.isPortrait ?? true ? 0.2 : 0.4))
            default :
                break
            }
            
            
            
            
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
            case 2 :
                section.boundarySupplementaryItems = [headerSupplementary]
            case 3 , 4 :
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerSupplementary]
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
        collectionView.register(ArticleDetailsSectionHeaderItem.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArticleDetailsSectionHeaderItem.reuseIdentifier)
    }
    
    private func configureDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource
            <ArticleDetailsSections, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
                switch indexPath.section {
                case 0 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverImageCollectionViewCell.reuseIdentifier, for: indexPath) as? CoverImageCollectionViewCell else {return nil}
                    guard let item = item as? [String] else {return nil}
                    cell.setupCell(coverURL: item[0], category: item[1])
                    return cell
                case 1 , 2 :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHolderCollectionViewCell.reuseIdentifier, for: indexPath) as? TextHolderCollectionViewCell else {return nil}
                    guard let item = item as? String else {return nil}
                    cell.setupCell(with: item , font: indexPath.section == 1 ? UIFont.boldSystemFont(ofSize: 24) : UIFont.systemFont(ofSize: 16) )
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
            guard let headerItem = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArticleDetailsSectionHeaderItem.reuseIdentifier, for: index) as? ArticleDetailsSectionHeaderItem else {return nil}
            headerItem.delegate = self
            switch index.section {
            case 0 , 1:
                return nil
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
}

// this extension contains the required ArticleDetailsSectionHeaderItemDelegate Methods

extension ArticleDetailsViewController : ArticleDetailsSectionHeaderItemDelegate {
    
    
    
    
    // this method allows us to control what will happen when the view more button is tapped
    // the section where this button will be called will determin what we will show
    // if tapped in the article body section it will show a viewcontroller with the article body
    // if tapped in the gallery or videos section it will show a viewcontroller that has a collectionview and gallery or video elements
    // inside it
    func handleViewAllAction(type: ViewAll) {
        switch type {
        case .videos :
            let vc = GalleryAndVideoViewController(with: nil, videoItem: self.article.videoGallery)
            navigationController?.pushViewController(vc, animated: true)
        
        case .images :
            let vc = GalleryAndVideoViewController(with: self.article.imagesGallery, videoItem: nil)
            navigationController?.pushViewController(vc, animated: true)
        case .article :
            let vc = ReadFullArticleViewController(with: self.article.body)
            vc.title = self.article.title
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
