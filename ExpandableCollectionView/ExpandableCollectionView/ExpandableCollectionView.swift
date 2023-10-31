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
    
    func magnify(viewAtIndex index: Int, completionHandler: @escaping (() -> Void)) {
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
        
        let duration: TimeInterval = config.shouldSkipInitialAnimation ? 0 : 1
        config.shouldSkipInitialAnimation = false
        UIView.animate(withDuration: duration, animations: { [weak self, oldWidth, oldHeight, newHeight, newWidth] in
            guard let self else { return }
            let xScaleFactor = CGFloat(newWidth) / oldWidth
            let yScaleFactor = CGFloat(newHeight) / oldHeight
            
            let oldLeadingPadding = view.frame.minX
            let oldTopPadding = view.frame.minY
            let newLeadingPadding = viewModel.getLeadingPadding(forViewAtIndex: index)
            let newTopPadding = viewModel.getTopPadding(forViewAtIndex: index)

            view.transform = view.transform.translatedBy(
                x: CGFloat(newLeadingPadding) - oldLeadingPadding,
                y: CGFloat(newTopPadding) - oldTopPadding
            ).scaledBy(
                x: xScaleFactor,
                y: yScaleFactor
            )
            
            for subviewToExclude in view.subviews.filter({ $0 is NonExpandableView }) {
                subviewToExclude.transform = subviewToExclude.transform.scaledBy(
                    x: 1 / xScaleFactor,
                    y: 1 / yScaleFactor
                )
            }

            for (index, view) in config.views.enumerated() where index != viewModel.magnifiedViewIndex {
                animateToCollapsedState(view: view, index: index)
            }
        }, completion: { _ in
            completionHandler()
        })
    }
    
    private func animateToCollapsedState(view: UIView, index: Int) {
        let newHeight = viewModel.getHeight(forViewAtIndex: index)
        let newWidth = viewModel.getWidth(forViewAtIndex: index)
        
        let oldLeadingPadding = view.frame.minX
        let oldTopPadding = view.frame.minY
        let newLeadingPadding = viewModel.getLeadingPadding(forViewAtIndex: index)
        let newTopPadding = viewModel.getTopPadding(forViewAtIndex: index)

        view.transform = view.transform.translatedBy(
            x: CGFloat(newLeadingPadding) - oldLeadingPadding,
            y: CGFloat(newTopPadding) - oldTopPadding
        ).scaledBy(
            x: (CGFloat(newWidth) / view.bounds.width),
            y: (CGFloat(newHeight) / view.bounds.height)
        )
    }
    
    func zoomOut() {
        viewModel.magnifiedViewIndex = nil
        UIView.animate(withDuration: 1, animations: { [weak self] in
            for view in self?.config.views ?? [] {
                view.transform = .identity
                if let subviewToZoom = view.subviews.first {
                    subviewToZoom.transform = .identity
                }
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
