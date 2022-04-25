//
//  RootSplitViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/23/22.
//

import UIKit

final class RootSplitViewController : UISplitViewController  {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        guard let navigationController = viewControllers.first as? UINavigationController else {return}
        guard let masterViewController = navigationController.viewControllers.first as? ArticlesFeedViewController else {return}
        guard let detailsNavigationController = viewControllers.last as? UINavigationController else {return}
        guard let detailsViewController = detailsNavigationController.viewControllers.first as? ArticleDetailsViewController else {return}
        
        masterViewController.delegate = detailsViewController
        detailsViewController.configureViewController()
        
    }
}


extension RootSplitViewController : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
           return true
    }
    
//    @available(iOS 14.0, *)
//    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
//        return .primary
//    }
}
