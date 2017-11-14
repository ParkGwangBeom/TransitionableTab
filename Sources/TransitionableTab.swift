//
//  TransitionableTab.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on {TODAY}.
//  Copyright © 2017 InteractiveStudio. All rights reserved.
//

import UIKit

public protocol TransitionableTab: UITabBarControllerDelegate {
    
    func transitionTimingFunction() -> CAMediaTimingFunction
    
    func transitionDuration() -> CFTimeInterval
    
    func fromTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation
    
    func toTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation
}

public extension TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.4
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeOut
    }
    
    func fromTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.from, direction: direction)
    }
    
    func toTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.to, direction: direction)
    }
    
    func animateTransition(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromViewCotroller = tabBarController.selectedViewController,
                fromViewCotroller != viewController else {
                    return false
        }
        
        let context = LayerContext(fromViewController: fromViewCotroller, toViewController: viewController)
        tabBarController.view.layer.insertSublayer(context.snapShotLayer!, at: 0)
        tabBarController.view.layer.insertSublayer(context.backgroundLayer!, at: 0)

        let selectedIndex = tabBarController.selectedIndex
        let shouldSelectIndex = tabBarController.viewControllers?.index(of: viewController) ?? 0
        let direction = Direction.check(selectedIndex: selectedIndex, shouldSelectIndex: shouldSelectIndex)

        (tabBarController as? TransitionableTab)?.animate(context: context, direction: direction)
        
        return true
    }
}

private struct AnimationKeys {
    static var toViewAnimationKey = "ToViewAnimationKey"
    static var fromViewAnimationKey = "FromViewAnimationKey"
}

private extension TransitionableTab {
    
    func animate(context: LayerContext, direction: Direction) {
        let fromAnimation = fromTransitionAnimation(layer: context.snapShotLayer!, direction: direction)
        let toAnimation = toTransitionAnimation(layer: context.toLayer, direction: direction)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(transitionDuration())
        CATransaction.setAnimationTimingFunction(transitionTimingFunction())
        CATransaction.setCompletionBlock {
            context.reset()
        }
        context.snapShotLayer?.add(fromAnimation, forKey: AnimationKeys.fromViewAnimationKey)
        context.toLayer.add(toAnimation, forKey: AnimationKeys.toViewAnimationKey)
        CATransaction.commit()
    }
}
