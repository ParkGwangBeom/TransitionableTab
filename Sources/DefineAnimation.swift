//
//  DefineAnimation.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 14..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

public struct DefineAnimation {
    
    public static func fade(_ type: TransitionViewType, min: CGFloat = 0, max: CGFloat = 1) -> CAAnimation {
        let fromOpacity = type == .from ? max : min
        let toOpacity = type == .to ? max : min
        return AnimationFactory.makeAnimation(type: .opacity, from: fromOpacity, to: toOpacity)
    }
    
    public static func scale(_ type: TransitionViewType, min: CGFloat = 0, max: CGFloat = 1) -> CAAnimation {
        let fromValue = type == .from ? max : min
        let toValue = type == .to ? max : min
        let opacityAnimation = fade(type)
        let scaleAnimation = AnimationFactory.makeAnimation(type: .scale, from: fromValue, to: toValue)
        return AnimationFactory.makeGroupAnimation([opacityAnimation, scaleAnimation])
    }
    
    public static func move(_ type: TransitionViewType, direction: Direction, bounceValue: CGFloat = 30) -> CAAnimation {
        let fromX = direction == .right ? bounceValue : -bounceValue
        let toX = direction == .left ? bounceValue : -bounceValue
        let opacity = fade(type)
        let translatation = type == .from ? AnimationFactory.makeAnimation(type: .translation, from: 0, to: toX) : AnimationFactory.makeAnimation(type: .translation, from: fromX, to: 0)
        return AnimationFactory.makeGroupAnimation([opacity, translatation])
    }
}
