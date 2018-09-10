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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewControllers?.flatMap{ ($0 as? UINavigationController)?.visibleViewController }.forEach {
            let searchBar = UISearchBar(frame: .zero)
            if #available(iOS 11.0, *) {
                searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            }
            searchBar.searchBarStyle = .prominent
            searchBar.placeholder = "Search"
            $0.navigationItem.titleView = searchBar
            
            $0.navigationController?.navigationBar.isTranslucent = false
            $0.navigationController?.navigationBar.tintColor = UIColor.white
            $0.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2666666667, green: 0.4117647059, blue: 0.6901960784, alpha: 1)
            
            let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(touch))
            $0.navigationItem.rightBarButtonItem = rightBarButtonItem
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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension TabBarController: TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.4
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeInOut
    }
    
    func fromTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        switch type {
        case .move: return DefineAnimation.move(.from, direction: direction)
        case .scale: return DefineAnimation.scale(.from)
        case .fade: return DefineAnimation.fade(.from)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = 0
            animation.toValue = -(layer?.frame.height ?? 0)
            return animation
        }
    }
    
    func toTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        switch type {
        case .move: return DefineAnimation.move(.to, direction: direction)
        case .scale: return DefineAnimation.scale(.to)
        case .fade: return DefineAnimation.fade(.to)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = (layer?.frame.height ?? 0)
            animation.toValue = 0
            return animation
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}


