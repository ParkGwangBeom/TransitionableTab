//
//  AnimationFactory.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 11..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

enum AnimationType: String {
    case opacity
    case scale = "transform.scale"
    case translation = "transform.translation.x"
    
    func animation<T>(from: T, to: T) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: rawValue)
        animation.fromValue = from
        animation.toValue = to
        return animation
    }
}

class AnimationFactory {
    
    static func makeAnimation<T>(type: AnimationType, from: T, to: T) -> CAAnimation {
        let animation = type.animation(from: from, to: to)
        return animation
    }
    
    static func makeGroupAnimation(_ animations: [CAAnimation]) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.animations = animations
        return group
    }
}
