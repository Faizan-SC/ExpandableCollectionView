//
//  ViewController.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var colors: [UIColor] = [.orange, .white, .cyan, .purple]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let expandableCollectionView = ExpandableCollectionView(
            config: ExpandableCollectionViewConfig(
                views: getViews(),
                expandedStateTotalHeight: Int(UIScreen.main.bounds.height),
                expandedStateTotalWidth: Int(UIScreen.main.bounds.width),
                collapsedStateTotalHeight: 100,
                collapsedStateTotalWidth: 50,
                collapsedStateTopPadding: 50,
                collapsedStateLeadingPadding: 20
            )
        )
        view.addSubview(expandableCollectionView)
        expandableCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        expandableCollectionView.setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expandableCollectionView.magnify(viewAtIndex: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            expandableCollectionView.zoomOut()
        }
    }
    
    private func getViews() -> [UIView] {
        var res: [UIView] = []
        for index in 0...3 {
            let view = UIView()
            view.backgroundColor = colors[index]
            let label = UILabel()
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
