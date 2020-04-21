//
//  BaseCarouselViewController.swift
//  Base
//
//  Created by Hoang Lu on 10/21/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class RxUIPageViewControllerDelegateProxy
    : DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>
    , DelegateProxyType
, UIPageViewControllerDelegate {
    public static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIPageViewControllerDelegate?, to object: UIPageViewController) {
        object.delegate = delegate
    }
    
    /// Typed parent object.
    public weak private(set) var pageViewController: UIPageViewController?
    
    /// - parameter pickerView: Parent object for delegate proxy.
    public init(pageViewController: ParentObject) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxUIPageViewControllerDelegateProxy.self)
    }
    
    // Register known implementationss
    public static func registerKnownImplementations() {
        self.register { RxUIPageViewControllerDelegateProxy(pageViewController: $0) }
    }
}

public extension Reactive where Base: UIPageViewController {
    var delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate> {
        return RxUIPageViewControllerDelegateProxy.proxy(for: base)
    }
}

public extension Reactive where Base: CarouselPage {
    var selectedIndex: ControlProperty<Int> {
        let value = base.pageViewController.rx.delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)))
            .flatMap{ args -> Observable<Int> in
                guard let completed = args[3] as? Bool, completed else {
                    return .empty()
                }
                return .just(self.base.selectedIndex)
            }
        
        let sink = Binder<Int>(self.base) { control, value in
            control.selectedIndex = value
        }
        return ControlProperty<Int>(values: value, valueSink: sink)
    }
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

public protocol CarouselPage: NSObjectProtocol {
    var pageViewController: UIPageViewController! { get }
    var selectedIndex: Int { get set }
    var subViewControllers: [UIViewController] { get set }
}

class BaseCarouselViewController<VM: GenericViewModel>: BaseViewController<VM>, CarouselPage, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
    var subViewControllers: [UIViewController] = []
    var pageViewController: UIPageViewController!
    
    var inTransition: Bool = false
    public var selectedIndex: Int {
        get {
            guard let selectedViewController = pageViewController.viewControllers?.first, let index = subViewControllers.firstIndex(of: selectedViewController) else {
                return 0
            }
            return index
        }
        set {
            guard newValue != selectedIndex else {
                return
            }
            transition(toIndex: newValue)
        }
    }
    
    override func initialize() {
        super.initialize()
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
		pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        inTransition = true
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        inTransition = false
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard selectedIndex > 0 else {
            return nil
        }
        return subViewControllers[selectedIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard selectedIndex < subViewControllers.count - 1 else {
            return nil
        }
        return subViewControllers[selectedIndex + 1]
    }

    func transition(toIndex index: Int) {
        guard index >= 0 && index < subViewControllers.count && index != selectedIndex, !inTransition else { return }
        let toViewController = subViewControllers[index]
         pageViewController.isPagingEnabled = false
         pageViewController.setViewControllers(
            [toViewController],
            direction: selectedIndex < index ? .forward : .reverse,
            animated: true,
            completion: { _ in self.pageViewController.isPagingEnabled = true }
        )
        
    }

    func setViewControllers(viewControllers: [UIViewController]) {
        guard !viewControllers.isEmpty else { return }

        self.subViewControllers = viewControllers
        self.pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: false)
        self.selectedIndex = 0
        
        viewControllers.forEach{ $0.view.layoutSubviews() }
    }
}
