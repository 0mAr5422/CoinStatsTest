//
//  GalleryAndVideoViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/25/22.
//

import UIKit

private enum GallerySections {
    case main
}
private enum LayoutType {
    case grid
    case descriptive
}
final class GalleryAndVideoViewController : UIViewController {
    
    private var segmentedControl : UISegmentedControl! = nil
    private var collectionView : UICollectionView! = nil
    private var dataSource : DDataSource<GallerySections , AnyHashable>! = nil
    
    private var galleryItems : [GalleryItem]?
    private var videoItems : [VideoItem]?
    init(with galleryItem : [GalleryItem]? , videoItem : [VideoItem]?) {
        self.galleryItems = galleryItem
        self.videoItems = videoItem
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("failed to initalize coder for GalleryAndVideoViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configureSegmentedControl()
        configureCollectionView()
        configureDataSource()
        
        var snap = NSDiffableDataSourceSnapshot<GallerySections , AnyHashable>()
        snap.appendSections([.main])
        if let galleryItems = galleryItems {
            snap.appendItems(galleryItems, toSection: .main)
        }
        if let videoItems = videoItems {
            snap.appendItems(videoItems, toSection: .main)
        }
        dataSource.apply(snap)
        
    }
 
    
    @objc private func handleSegmentedControlAction(_ sender : UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            
            collectionView.collectionViewLayout = collectionViewLayout(layoutType: .grid)
            
        }
        else {
            collectionView.collectionViewLayout = collectionViewLayout(layoutType: .descriptive)
           
        }
    }
}

//MARK: UI Configuration

extension GalleryAndVideoViewController {
    private func configureSegmentedControl(){
        segmentedControl = UISegmentedControl(items: ["Grid" , "Descriptive"])
        segmentedControl.sizeToFit()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.clipsToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlAction(_:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    private func collectionViewLayout(layoutType : LayoutType) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            var itemSize : NSCollectionLayoutSize!
            var groupSize : NSCollectionLayoutSize!
            
            switch layoutType {
            case .grid:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(self.windowInterfaceOrientation?.isPortrait ?? true ?  0.3 : 0.6))
            case .descriptive:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(self.windowInterfaceOrientation?.isPortrait ?? true ?  0.4 : 0.7))
            }
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: layoutType == .grid ? 2 : 1)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10)
            return section
            
        }
        return layout
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout(layoutType: .grid))
        
        view.addSubview(collectionView)
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        collectionView.backgroundColor = .systemGray6
        collectionView.register(GalleryAndVideoItemCollectionViewCell.self, forCellWithReuseIdentifier: GalleryAndVideoItemCollectionViewCell.reuseIdentifier)
    }
    private func configureDataSource(){
        
        dataSource = DDataSource<GallerySections , AnyHashable>(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {return nil}
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryAndVideoItemCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryAndVideoItemCollectionViewCell else {return nil}
            if let _ = self.galleryItems {
                guard let item = itemIdentifier as? GalleryItem else {return nil}
                
                cell.setupCellWith(galleryItem: item)
                return cell
            }
            if let _ = self.videoItems {
                guard let item = itemIdentifier as? VideoItem else {return nil}
                
                cell.setupCell(with: item)
                return cell
            }
            
                return nil
            
        })
        
    }
}


extension GalleryAndVideoViewController : UICollectionViewDelegate {
    
    
}
