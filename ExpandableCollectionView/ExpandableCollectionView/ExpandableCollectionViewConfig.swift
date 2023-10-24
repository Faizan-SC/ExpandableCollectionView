//
//  ExpandableCollectionViewConfig.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import Foundation
import UIKit

final class ExpandableCollectionViewConfig {
    let views: [UIView]
    let expandedStateTotalHeight: Int
    let expandedStateTotalWidth: Int
    let collapsedStateTotalHeight: Int
    let collapsedStateTotalWidth: Int
    let collapsedStateTopPadding: Int
    let collapsedStateLeadingPadding: Int
  
    init(
        views: [UIView],
        expandedStateTotalHeight: Int,
        expandedStateTotalWidth: Int,
        collapsedStateTotalHeight: Int,
        collapsedStateTotalWidth: Int,
        collapsedStateTopPadding: Int,
        collapsedStateLeadingPadding: Int
    ) {
        self.views = views
        self.expandedStateTotalHeight = expandedStateTotalHeight
        self.expandedStateTotalWidth = expandedStateTotalWidth
        self.collapsedStateTotalHeight = collapsedStateTotalHeight
        self.collapsedStateTotalWidth = collapsedStateTotalWidth
        self.collapsedStateTopPadding = collapsedStateTopPadding
        self.collapsedStateLeadingPadding = collapsedStateLeadingPadding
    }
}
