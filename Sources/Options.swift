//
//  Options.swift
//  TransitionableTab-iOS
//
//  Created by gwangbeom on 2017. 11. 12..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit

public enum Direction {
    case left
    case right
    
    init(selectedIndex: Int, shouldSelectIndex: Int) {
        self = selectedIndex > shouldSelectIndex ? .left : .right
    }
}

public enum TransitionViewType: Int {
    case to
    case from
}
