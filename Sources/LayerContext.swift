//
//  LayerContext.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 14..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

class LayerContext {
    
    var backgroundLayer: CALayer?
    var fakeLayer: CALayer?
    var fakeNavigationBarLayer: CALayer?
    weak var toLayer: CALayer?
    
    init(fromViewController: UIViewController, toViewController: UIViewController) {
        toLayer = toViewController.pureViewController.view.layer
        makeBackgroundLayer(toViewController.pureViewController)
        makeFakeLayer(fromViewController.pureViewController)
        makeFakeNavigationBarLayerIfExists(fromViewController)
    }
    
    func reset() {
        fakeLayer?.removeFromSuperlayer()
        backgroundLayer?.removeFromSuperlayer()
        fakeNavigationBarLayer?.removeFromSuperlayer()
        fakeLayer = nil
        backgroundLayer = nil
        fakeNavigationBarLayer = nil
    }
}

private extension LayerContext {
    
    func makeFakeLayer(_ viewController: UIViewController) {
        fakeLayer = viewController.view.snapshotView(afterScreenUpdates: false)?.layer
        fakeLayer?.frame = viewController.view.bounds
    }
    
    func makeBackgroundLayer(_ viewController: UIViewController) {
        backgroundLayer = CALayer()
        backgroundLayer?.frame = viewController.view.bounds
        backgroundLayer?.backgroundColor = viewController.view.backgroundColor?.cgColor
    }
    
    func makeFakeNavigationBarLayerIfExists(_ viewController: UIViewController) {
        fakeNavigationBarLayer = (viewController as? UINavigationController)?.navigationBar.snapshotView(afterScreenUpdates: false)?.layer
        fakeNavigationBarLayer?.frame =  (viewController as? UINavigationController)?.navigationBar.frame ?? .zero
    }
}

private extension UIViewController {
    
    var pureViewController: UIViewController {
        return (self as? UINavigationController)?.visibleViewController ?? self
    }
}
