//
//  LayerContext.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 14..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

class LayerContext {
    
    var snapShotLayer: CALayer?
    var backgroundLayer: CALayer?
    var toLayer: CALayer
    
    init(fromViewController: UIViewController, toViewController: UIViewController) {
        toLayer = toViewController.view.layer
        makeSnapShotLayer(fromViewController)
        makeBackgroundLayer(toViewController)
    }
    
    func makeSnapShotLayer(_ viewController: UIViewController) {
        snapShotLayer = viewController.view.snapshotView(afterScreenUpdates: false)?.layer
        snapShotLayer?.frame = viewController.view.bounds
    }
    
    func makeBackgroundLayer(_ viewController: UIViewController) {
        backgroundLayer = CALayer()
        backgroundLayer?.frame = viewController.view.bounds
        
        // TODO: refactoring
        if let navigation = viewController as? UINavigationController {
            backgroundLayer?.backgroundColor = navigation.visibleViewController?.view.backgroundColor?.cgColor
        } else {
            backgroundLayer?.backgroundColor = viewController.view.backgroundColor?.cgColor
        }
    }
    
    func reset() {
        snapShotLayer?.removeFromSuperlayer()
        backgroundLayer?.removeFromSuperlayer()
        snapShotLayer = nil
        backgroundLayer = nil
    }
}
