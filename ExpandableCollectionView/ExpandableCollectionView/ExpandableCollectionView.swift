//
//  ExpandableCollectionView.swift
//  ExpandableCollectionView
//
//  Created by Faizan Memon on 24/10/23.
//

import Foundation
import UIKit
import SnapKit

final class ExpandableCollectionView: UIView {
    let config: ExpandableCollectionViewConfig
    let viewModel: ExpandableCollectionViewModel

    init(config: ExpandableCollectionViewConfig) {
        self.config = config
        self.viewModel = ExpandableCollectionViewModel(config: config)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        for (index, view) in config.views.enumerated() {
            self.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(viewModel.getTopPadding(forViewAtIndex: index))
                make.height.equalTo(viewModel.getHeight(forViewAtIndex: index))
                make.width.equalTo(viewModel.getWidth(forViewAtIndex: index))
                make.leading.equalToSuperview().offset (viewModel.getLeadingPadding(forViewAtIndex: index))
            }
        }
    }
    
    func magnify(viewAtIndex index: Int) {
        viewModel.magnifiedViewIndex = index
        let view = config.views[index]
        self.sendSubviewToBack(view) // to ensure smaller views are always visible
        let oldWidth = view.bounds.width
        let oldHeight = view.bounds.height
        let newHeight = viewModel.getHeight(forViewAtIndex: index)
        let newWidth = viewModel.getWidth(forViewAtIndex: index)
        layoutIfNeeded()
        for (index, view) in config.views.enumerated() {
            view.setAnchorPoint(viewModel.getAnchorPoint(forViewAtIndex: index))
        }
        layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: { [weak self, oldWidth, oldHeight, newHeight, newWidth] in
            guard let self else { return }
            view.transform = view.transform.scaledBy(
                x: (CGFloat(newWidth) / oldWidth),
                y: (CGFloat(newHeight) / oldHeight)
            )
            for (index, view) in config.views.enumerated() where index != viewModel.magnifiedViewIndex {
                animateToCollapsedState(view: view, index: index)
            }
        })
    }
    
    private func animateToCollapsedState(view: UIView, index: Int) {
        let oldSize = view.bounds.applying(view.transform)
        let oldFrame = view.frame.applying(view.transform)
        let newHeight = viewModel.getHeight(forViewAtIndex: index)
        let newWidth = viewModel.getWidth(forViewAtIndex: index)
        
        let oldLeadingPadding = oldFrame.origin.x
        let oldTopPadding = oldFrame.origin.y
        let newLeadingPadding = viewModel.getLeadingPadding(forViewAtIndex: index)
        let newTopPadding = viewModel.getTopPadding(forViewAtIndex: index)
        
        print(newHeight.description + " " + newWidth.description + " " + newLeadingPadding.description + " " + newTopPadding.description)
        print(oldLeadingPadding.description)
        print(oldTopPadding.description)
        print(oldSize.width)
        print(oldSize.height)
        view.transform = view.transform.translatedBy(
            x: CGFloat(newLeadingPadding) - oldLeadingPadding,
            y: CGFloat(newTopPadding) - oldTopPadding
        ).scaledBy(
            x: (CGFloat(newWidth) / oldSize.width),
            y: (CGFloat(newHeight) / oldSize.height)
        )
    }
    
    func zoomOut() {
        viewModel.magnifiedViewIndex = nil
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self else { return }
            for (index, view) in config.views.enumerated() {
                animateToCollapsedState(view: view, index: index)
            }
        })
    }
}

extension UIView {

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
