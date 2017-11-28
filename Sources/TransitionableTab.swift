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
            return true
        }
        
        let context = LayerContext(fromViewController: fromViewCotroller, toViewController: viewController)
        tabBarController.view.layer.insertSublayer(context.toBackgroundLayer!, at: 0)
        tabBarController.view.layer.insertSublayer(context.fakeLayer!, at: 0)
        tabBarController.view.layer.insertSublayer(context.backgroundLayer!, at: 0)
        addFakeNavigationBarLayerIfNeeded(in: tabBarController, context: context)
        
        let selectedIndex = tabBarController.selectedIndex
        let shouldSelectIndex = tabBarController.viewControllers?.index(of: viewController) ?? 0
        let direction = Direction(selectedIndex: selectedIndex, shouldSelectIndex: shouldSelectIndex)

        (tabBarController as? TransitionableTab)?.animate(context: context, direction: direction)
        
        return true
    }
}

private struct AnimationKeys {
    static var toViewAnimationKey = "ToViewAnimationKey"
    static var fromViewAnimationKey = "FromViewAnimationKey"
    static var navigationBarAnimationKey = "navigationBarAnimationKey"
    static var backgroundAnimatonKey = "BackgroundAnimationKey"
}

private extension TransitionableTab {
    
    func addFakeNavigationBarLayerIfNeeded(in tabBarController: UITabBarController, context: LayerContext) {
        guard let fakeNavigationBar = context.fakeNavigationBarLayer else { return }
        tabBarController.view.layer.addSublayer(fakeNavigationBar)
    }
    
    func animate(context: LayerContext, direction: Direction) {
        let fromAnimation = fromTransitionAnimation(layer: context.fakeLayer!, direction: direction)
        let toAnimation = toTransitionAnimation(layer: context.toLayer!, direction: direction)
        let backgroundAnimation = AnimationFactory.makeAnimation(type: .opacity, from: 0, to: 1)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(transitionDuration())
        CATransaction.setAnimationTimingFunction(transitionTimingFunction())
        CATransaction.setCompletionBlock {
            context.reset()
        }
        
        if let fakeNavigationBar = context.fakeNavigationBarLayer {
            let fadeAnimation = AnimationFactory.makeAnimation(type: .opacity, from: 1, to: 0)
            fadeAnimation.isRemovedOnCompletion = false
            fadeAnimation.fillMode = kCAFillModeForwards
            fakeNavigationBar.add(fadeAnimation, forKey: AnimationKeys.navigationBarAnimationKey)
        }

        context.toBackgroundLayer?.add(backgroundAnimation, forKey: AnimationKeys.backgroundAnimatonKey)
        context.fakeLayer?.add(fromAnimation, forKey: AnimationKeys.fromViewAnimationKey)
        context.toLayer?.add(toAnimation, forKey: AnimationKeys.toViewAnimationKey)
        CATransaction.commit()
    }
}
