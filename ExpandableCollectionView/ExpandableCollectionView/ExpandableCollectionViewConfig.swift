//
//  ExpandableCollectionViewConfig.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import Foundation
import UIKit

final class ExpandableCollectionViewConfig {
    var views: [UIView]
    let expandedStateTotalHeight: Int
    let expandedStateTotalWidth: Int
    let collapsedStateTotalMinHeight: Int
    let collapsedStateTotalHeight: Int
    let collapsedStateTotalWidth: Int
    let collapsedStateTopPadding: Int
    let collapsedStateLeadingPadding: Int
    var shouldSkipInitialAnimation: Bool
  
    init(
        views: [UIView],
        expandedStateTotalHeight: Int,
        expandedStateTotalWidth: Int,
        collapsedStateTotalMinHeight: Int,
        collapsedStateTotalHeight: Int,
        collapsedStateTotalWidth: Int,
        collapsedStateTopPadding: Int,
        collapsedStateLeadingPadding: Int,
        shouldSkipInitialAnimation: Bool
    ) {
        self.views = views
        self.expandedStateTotalHeight = expandedStateTotalHeight
        self.expandedStateTotalWidth = expandedStateTotalWidth
        self.collapsedStateTotalMinHeight = collapsedStateTotalMinHeight
        self.collapsedStateTotalHeight = collapsedStateTotalHeight
        self.collapsedStateTotalWidth = collapsedStateTotalWidth
        self.collapsedStateTopPadding = collapsedStateTopPadding
        self.collapsedStateLeadingPadding = collapsedStateLeadingPadding
        self.shouldSkipInitialAnimation = shouldSkipInitialAnimation
    }
}
