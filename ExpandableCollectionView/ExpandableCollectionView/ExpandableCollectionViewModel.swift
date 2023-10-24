//
//  ExpandableCollectionViewModel.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import Foundation

final class ExpandableCollectionViewModel {
    let config: ExpandableCollectionViewConfig
    var magnifiedViewIndex: Int? = nil
    
    private var totalElements: Int {
        return config.views.count
    }

    init(config: ExpandableCollectionViewConfig) {
        self.config = config
    }
    
    func getHeight(forViewAtIndex index: Int) -> Int {
        switch totalElements {
        case 1:
            return config.expandedStateTotalHeight
        case 2:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalHeight : config.collapsedStateTotalHeight / (totalElements - 1)
            } else {
                return config.expandedStateTotalHeight / 2
            }
        case 3:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalHeight : config.collapsedStateTotalHeight / (totalElements - 1)
            } else {
                return config.expandedStateTotalHeight / 2
            }
        case 4:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalHeight : config.collapsedStateTotalHeight / (totalElements - 1)
            } else {
                return config.expandedStateTotalHeight / 2
            }
        default:
            return 0
        }
    }
    
    func getWidth(forViewAtIndex index: Int) -> Int {
        switch totalElements {
        case 1:
            return config.expandedStateTotalWidth
        case 2:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalWidth : config.collapsedStateTotalWidth
            } else {
                return config.expandedStateTotalWidth
            }
        case 3:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalWidth : config.collapsedStateTotalWidth
            } else {
                return index == 0 ? config.expandedStateTotalWidth : config.expandedStateTotalWidth / 2
            }
        case 4:
            if let magnifiedViewIndex {
                return magnifiedViewIndex == index ? config.expandedStateTotalWidth : config.collapsedStateTotalWidth
            } else {
                return config.expandedStateTotalWidth / 2
            }
        default:
            return 0
        }
    }
    
    func getTopPadding(forViewAtIndex index: Int) -> Int {
        switch totalElements {
        case 1:
            return 0
        case 2:
            if magnifiedViewIndex != nil {
                return config.collapsedStateTopPadding
            } else {
                return index == 0 ? 0 : config.expandedStateTotalHeight / 2
            }
        case 3:
            if let magnifiedViewIndex {
                if magnifiedViewIndex == index {
                    return config.collapsedStateTopPadding
                }

                let collapsedCellHeight = config.collapsedStateTotalHeight / totalElements
                return collapsedCellHeight * (index - 1)
            } else {
                return index == 0 ? 0 : config.expandedStateTotalHeight / 2
            }
        case 4:
            if let magnifiedViewIndex {
                if magnifiedViewIndex == index {
                    return config.collapsedStateTopPadding
                }

                let collapsedCellHeight = config.collapsedStateTotalHeight / totalElements
                return config.collapsedStateTopPadding + collapsedCellHeight * (index - 1)
            } else {
                return (index == 0 || index == 1) ? 0 : config.expandedStateTotalHeight / 2
            }
        default:
            return 0
        }
    }
    
    func getLeadingPadding(forViewAtIndex index: Int) -> Int {
        if let magnifiedViewIndex, totalElements > 1 {
            return index == magnifiedViewIndex ? 0 : config.collapsedStateLeadingPadding
        }
        switch totalElements {
        case 1, 2:
            return 0
        case 3:
            return index == 2 ? config.expandedStateTotalWidth / 2 : 0
        case 4:
            return index == 0 || index == 2 ? 0 : config.expandedStateTotalWidth / 2
        default:
            return 0
        }
    }
    
    func getAnchorPoint(forViewAtIndex index: Int) -> CGPoint {
        if magnifiedViewIndex != nil {
            return .zero
        }
        switch totalElements {
        case 1: return .zero
        case 2:
            return index == 0 ? .zero : CGPoint(x: 0.5, y: 1)
        case 3:
            switch index {
            case 0:
                return CGPoint(x: 0.5, y: 0)
            case 1:
                return CGPoint(x: 0, y: 1)
            case 2:
                return CGPoint(x: 1, y: 1)
            default:
                return .zero
            }
        case 4:
            switch index {
            case 0:
                return CGPoint(x: 0, y: 0)
            case 1:
                return CGPoint(x: 1, y: 0)
            case 2:
                return CGPoint(x: 0, y: 1)
            case 3:
                return CGPoint(x: 1, y: 1)
            default:
                return .zero
            }
        default:
            return .zero
        }
    }
}
