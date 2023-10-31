//
//  ViewController.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var colors: [UIColor] = [.orange, .lightGray, .cyan, .purple]
    var expandableCollectionView: ExpandableCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let collectionView = setupExpandableCollectionView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.expandableCollectionView?.magnify(viewAtIndex: 0) { }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            let collectionView = self.setupExpandableCollectionView(
                config: ExpandableCollectionViewConfig(
                    views: getViews().dropLast(1),
                    expandedStateTotalHeight: Int(UIScreen.main.bounds.height),
                    expandedStateTotalWidth: Int(UIScreen.main.bounds.width),
                    collapsedStateTotalMinHeight: 60,
                    collapsedStateTotalHeight: 100,
                    collapsedStateTotalWidth: 50,
                    collapsedStateTopPadding: 50,
                    collapsedStateLeadingPadding: 20,
                    shouldSkipInitialAnimation: true
                )
            )
            self.view.layoutIfNeeded()
            collectionView.magnify(viewAtIndex: 0) {
                self.expandableCollectionView?.removeFromSuperview()
                collectionView.isHidden = false
                self.expandableCollectionView = collectionView
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { [weak self] in
            self?.expandableCollectionView?.zoomOut()
        }

        self.expandableCollectionView = collectionView
    }
    
    private func setupExpandableCollectionView(config: ExpandableCollectionViewConfig? = nil) -> ExpandableCollectionView {
        let expandableCollectionView = ExpandableCollectionView(
            config: config ?? ExpandableCollectionViewConfig(
                views: getViews(),
                expandedStateTotalHeight: Int(UIScreen.main.bounds.height),
                expandedStateTotalWidth: Int(UIScreen.main.bounds.width),
                collapsedStateTotalMinHeight: 60,
                collapsedStateTotalHeight: 100,
                collapsedStateTotalWidth: 50,
                collapsedStateTopPadding: 50,
                collapsedStateLeadingPadding: 20,
                shouldSkipInitialAnimation: false
            )
        )
        expandableCollectionView.isHidden = false
        view.addSubview(expandableCollectionView)
        expandableCollectionView.snp.makeConstraints { make in
            make.directionalVerticalEdges.directionalHorizontalEdges.equalToSuperview()
            make.center.equalToSuperview()
        }

        expandableCollectionView.setupUI()
        return expandableCollectionView
    }

    private func getViews() -> [UIView] {
        var res: [UIView] = []
        for index in 0...3 {
            let view = UIView()
            view.backgroundColor = colors[index]
            let label = NonExpandableLabel()
            label.text = "Hey there !"
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.width.equalTo(100)
                make.center.equalToSuperview()
            }
            res.append(view)
        }
        
        return res
    }
}

final class NonExpandableLabel: UILabel, NonExpandableView {
    
}
