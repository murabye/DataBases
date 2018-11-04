//
//  BaseRouter.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

import UIKit

public protocol BaseRouterProtocol {
    var _module: BaseModule! { get set }
    
    func show(inWindow window: UIWindow?, embedInNavController: Bool, setupData: Any?, makeKeyAndVisible: Bool)
    func show(from: UIViewController, embedInNavController: Bool, setupData: Any?)
    func show(from containerView: UIViewController, insideView targetView: UIView, setupData: Any?)
}

open class BaseRouter: BaseRouterProtocol {
    public weak var _module: BaseModule!
    
    open func show(inWindow window: UIWindow?, embedInNavController: Bool = false, setupData: Any? = nil, makeKeyAndVisible: Bool = true) {
        process(setupData: setupData)
        let view = embedInNavController ? embedInNavigationController() : _module._view as! UIViewController
        window?.rootViewController = view
        if makeKeyAndVisible {
            window?.makeKeyAndVisible()
        }
    }
    
    open func show(from: UIViewController, embedInNavController: Bool = false, setupData: Any? = nil) {
        process(setupData: setupData)
        let view = embedInNavController ? embedInNavigationController() : _module._view as! UIViewController
        from.show(view, sender: nil)
    }
    
    public func show(from containerView: UIViewController, insideView targetView: UIView, setupData: Any? = nil) {
        process(setupData: setupData)
        addAsChildView(ofView: containerView, insideContainer: targetView)
    }
    
    required public init() { }
    
    var view: UIViewController {
        return _module._view as! UIViewController
    }
}

//MARK: - Process possible setup data
private extension BaseRouter {
    func process(setupData: Any?) {
        if let data = setupData {
            _module._presenter.setupView(data: data)
        }
    }
}

//MARK: - Embed view in navigation controller
public extension BaseRouter {
    private func getNavigationController() -> UINavigationController? {
        if let nav = view.navigationController {
            return nav
        } else if let parent = view.parent {
            if let parentNav = parent.navigationController {
                return parentNav
            }
        }
        return nil
    }
    
    func embedInNavigationController() -> UINavigationController {
        return getNavigationController() ?? UINavigationController(rootViewController: view)
    }
}

//MARK: - Embed view in a container view
public extension BaseRouter {
    func addAsChildView(ofView parentView: UIViewController, insideContainer containerView: UIView) {
        parentView.addChild(view)
        containerView.addSubview(view.view)
        stretchToBounds(containerView, view: view.view)
        view.didMove(toParent: parentView)
    }
    
    private func stretchToBounds(_ holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let pinDirections: [NSLayoutConstraint.Attribute] = [.top, .bottom, .left, .right]
        let pinConstraints = pinDirections.map { direction -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view, attribute: direction, relatedBy: .equal,
                                      toItem: holderView, attribute: direction, multiplier: 1.0, constant: 0)
        }
        holderView.addConstraints(pinConstraints)
    }
}
