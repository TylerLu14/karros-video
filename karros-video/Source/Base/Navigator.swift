//
//  Navigator.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import UIKit

protocol Navigator {
    associatedtype Destination
    var navigationController: UINavigationController? { get }
    func pop(transitionStyle: CATransitionType?)
    func popToRoot(transitionStyle: CATransitionType?)
    func push(to destination: Destination, transitionStyle: CATransitionType?)
    func present(to destination: Destination, transitionStyle: UIModalTransitionStyle, presentationStyle: UIModalPresentationStyle)
    func makeViewController(for destination: Destination) -> UIViewController
}

extension Navigator {
    func getTransition(transitionStyle: CATransitionType) -> CATransition {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = transitionStyle
        return transition
    }
    
    func push(to destination: Destination, transitionStyle: CATransitionType? = nil) {
        if let transitionStyle = transitionStyle {
            let transition = getTransition(transitionStyle: transitionStyle)
            navigationController?.view.layer.add(transition, forKey: nil)
        }
        
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: transitionStyle == nil)
    }
    
    func pop(transitionStyle: CATransitionType? = nil) {
        if let transitionStyle = transitionStyle {
            let transition = getTransition(transitionStyle: transitionStyle)
            navigationController?.view.layer.add(transition, forKey: nil)
        }
        navigationController?.popViewController(animated: transitionStyle == nil)
        
    }
    
    func popToRoot(transitionStyle: CATransitionType? = nil) {
        if let transitionStyle = transitionStyle {
            let transition = getTransition(transitionStyle: transitionStyle)
            navigationController?.view.layer.add(transition, forKey: nil)
        }
        navigationController?.popToRootViewController(animated: transitionStyle == nil)
    }
	
	func pop(fromPage: AnyClass, transitionStyle: CATransitionType? = nil) {
		guard let controllers = navigationController?.viewControllers,
		let pageIndex = controllers.firstIndex(where: {$0.isKind(of: fromPage)}) else { return }
		if let transitionStyle = transitionStyle {
            let transition = getTransition(transitionStyle: transitionStyle)
            navigationController?.view.layer.add(transition, forKey: nil)
        }
		navigationController?.popToViewController(controllers[pageIndex-1], animated: transitionStyle == nil)
	}
    
    func present(to destination: Destination, transitionStyle: UIModalTransitionStyle = .coverVertical, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        let viewController = makeViewController(for: destination)
        viewController.modalPresentationStyle = presentationStyle
        viewController.modalTransitionStyle = transitionStyle
        navigationController?.present(viewController, animated: true)
    }
    
    func set(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func replace(by destination: Destination) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            let viewController = self.makeViewController(for: destination)
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.8, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        
        if let presented = window.rootViewController?.presentedViewController {
            presented.dismiss(animated: false, completion: dismissCompletion)
        } else if let tabBar = window.rootViewController as? UITabBarController {
            tabBar.viewControllers?
                .compactMap{ $0 as? UINavigationController }
                .forEach{ vc in vc.popToRootViewController(animated: false) }
            tabBar.setViewControllers(nil, animated: false)
            dismissCompletion()
        } else {
            dismissCompletion()
        }
        
        
    }
}
