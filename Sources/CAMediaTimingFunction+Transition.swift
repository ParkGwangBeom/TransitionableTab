//
//  CAMediaTimingFunction+Transition.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 12..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

public extension CAMediaTimingFunction {
    
    static let linear = CAMediaTimingFunction(name: .linear)
    
    static let easeIn = CAMediaTimingFunction(name: .easeIn)
    
    static let easeOut = CAMediaTimingFunction(name: .easeOut)
    
    static let easeInOut = CAMediaTimingFunction(name: .easeInEaseOut)
}
