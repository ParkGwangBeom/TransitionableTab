//
//  CAMediaTimingFunction+Transition.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 12..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

public extension CAMediaTimingFunction {
    
    static let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    
    static let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    
    static let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    static let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
}
