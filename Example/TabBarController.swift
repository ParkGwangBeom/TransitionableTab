//
//  TabBarController.swift
//  Example
//
//  Created by gwangbeom on 2017. 11. 11..
//  Copyright © 2017년 InteractiveStudio. All rights reserved.
//

import UIKit
import TransitionableTab

enum Type: String {
    case move
    case fade
    case scale
    case custom
    
    static var all: [Type] = [.move, .scale, .fade, .custom]
}

class TabBarController: UITabBarController {
    
    var type: Type = .move
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        viewControllers?.forEach {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 30, width: 200, height: 100)
            button.setTitle("Chaange Animation", for: .normal)
            button.addTarget(self, action: #selector(touch), for: .touchUpInside)
            $0.view.addSubview(button)
        }
    }
    
    @objc
    func touch() {
        let actionSheet = UIAlertController(title: "Animations", message: nil, preferredStyle: .actionSheet)
        Type.all.forEach {
            let action = UIAlertAction(title: $0.rawValue, style: .default) { [weak self] action in
                self?.type = Type(rawValue: action.title ?? "") ?? .move
            }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

extension TabBarController: TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.5
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeInOut
    }
    
    func fromTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        switch type {
        case .move: return DefineAnimation.move(.from, direction: direction)
        case .scale: return DefineAnimation.scale(.from)
        case .fade: return DefineAnimation.fade(.from)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = 0
            animation.toValue = -layer.frame.height
            return animation
        }
    }
    
    func toTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        switch type {
        case .move: return DefineAnimation.move(.to, direction: direction)
        case .scale: return DefineAnimation.scale(.to)
        case .fade: return DefineAnimation.fade(.to)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = layer.frame.height
            animation.toValue = 0
            return animation
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}


