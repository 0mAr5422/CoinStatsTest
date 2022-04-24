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
