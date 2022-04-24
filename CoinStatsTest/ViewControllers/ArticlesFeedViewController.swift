//
//  ViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import UIKit


final class ArticlesFeedViewController: UIViewController {
    private var collectionView : UICollectionView! = nil
    private var dataSource : DDataSource<FeedArticleSections,FeedArticle>! = nil
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Articles"
        view.backgroundColor = .systemGray6
        
        configureCollectionView()
        configureDataSource()
        
        let feedViewModel = FeedViewModel()
        self.view.addActivityIndicator()
        view.backgroundColor = .blue
        DispatchQueue.global(qos: .userInitiated).async {

            feedViewModel.performDataFetch(with: [:]) {[weak self] model, err in
                guard let self = self else {return}
            if let _ = err {
                print(err)
                return
            }
            else {
                DispatchQueue.main.async {
                    self.view.removeActivityIndicator()
                    var snap = NSDiffableDataSourceSnapshot<FeedArticleSections , FeedArticle>()
                    snap.appendSections([.main])
                    snap.appendItems(model, toSection: .main)
                    self.dataSource.apply(snap)
                    
                }
                
            }
            }
        }
        
        
    }

}


//MARK: UI Configuration

extension ArticlesFeedViewController {
    
    //MARK: Compositional layout configuration
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            var groupSize : NSCollectionLayoutSize! = nil
            if UIDevice.current.userInterfaceIdiom == .phone {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(self?.windowInterfaceOrientation?.isPortrait ?? true ? 0.4 : 0.9))
            }
            else {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
            }
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        return layout
    }
    
    //MARK: CollectionView Configuration and Cell Registration
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds , collectionViewLayout: collectionViewLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        collectionView.backgroundColor = .systemGray6
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
    }
    
    //MARK: DiffableDataSource Configuration
    
    private func configureDataSource(){
        // dequeing cell of type ArticleCollectionViewCell and configuring for every item 
        dataSource = UICollectionViewDiffableDataSource
            <FeedArticleSections, FeedArticle>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: FeedArticle) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ArticleCollectionViewCell else { fatalError("Could not dequeue ArticleCell with reuse identifier \(ArticleCollectionViewCell.reuseIdentifier)") }
                
                cell.setupCell(with: item)
                
                
            return cell
        }
        
        
        
    }
}