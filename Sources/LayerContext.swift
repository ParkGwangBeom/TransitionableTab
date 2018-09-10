//
//  LayerContext.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 14..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

// MARK: toBackgroundLayer 적용하기

class LayerContext {

    var fakeLayer: CALayer?
    var fakeNavigationBarLayer: CALayer?
    
    var backgroundLayer: CALayer?
    var toBackgroundLayer: CALayer?
    weak var toLayer: CALayer?
    
    init(fromViewController: UIViewController, toViewController: UIViewController) {
        toLayer = toViewController.pureViewController.view.layer
        toBackgroundLayer = makeLayer(toViewController.pureViewController)
        backgroundLayer = makeLayer(toViewController.pureViewController)
        makeFakeLayer(fromViewController.pureViewController)
        makeFakeNavigationBarLayerIfExists(fromViewController)
    }
    
    func reset() {
        backgroundLayer?.removeFromSuperlayer()
        toBackgroundLayer?.removeFromSuperlayer()
        fakeLayer?.removeFromSuperlayer()
        fakeNavigationBarLayer?.removeFromSuperlayer()
        
        backgroundLayer = nil
        toBackgroundLayer = nil
        fakeLayer = nil
        fakeNavigationBarLayer = nil
    }
}

private extension LayerContext {
    
    func makeFakeLayer(_ viewController: UIViewController) {
        guard let snapShot = viewController.view.snapshotView(afterScreenUpdates: false)?.layer else {
            return
        }
        snapShot.frame = CGRect(x: viewController.view.frame.width,
                                 y: viewController.view.frame.origin.y,
                                 width: viewController.view.frame.width,
                                 height: viewController.view.frame.height)
        
        fakeLayer = CALayer()
        fakeLayer?.backgroundColor = viewController.view.backgroundColor?.cgColor
        fakeLayer?.frame = CGRect(x: -viewController.view.bounds.width,
                                  y: viewController.view.bounds.origin.y,
                                  width: (3 * viewController.view.bounds.width),
                                  height: viewController.view.bounds.height)
        fakeLayer?.addSublayer(snapShot)
    }
    
    func makeFakeNavigationBarLayerIfExists(_ viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController,
            let navigationBarLayer = navigationController.navigationBar.snapshotView(afterScreenUpdates: false)?.layer else {
                return
        }
        
        // TODO: Refactoring
        navigationBarLayer.frame = navigationController.navigationBar.frame
        
        let fakeNavigationBarLayer = CALayer()
        fakeNavigationBarLayer.backgroundColor = navigationController.navigationBar.barTintColor?.cgColor
        fakeNavigationBarLayer.frame = CGRect(x: 0, y: 0, width: navigationBarLayer.frame.width, height: UIApplication.shared.statusBarFrame.height + navigationBarLayer.frame.height)
        fakeNavigationBarLayer.addSublayer(navigationBarLayer)
        
        self.fakeNavigationBarLayer = fakeNavigationBarLayer
    }
    
    func makeLayer(_ viewController: UIViewController) -> CALayer {
        let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        layer.backgroundColor = viewController.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        return layer
    }
}

private extension UIViewController {
    
    var pureViewController: UIViewController {
        return (self as? UINavigationController)?.visibleViewController ?? self
    }
}
