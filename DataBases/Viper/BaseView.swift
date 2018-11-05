//
//  BaseView.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

import UIKit

public protocol BaseViewProtocol: class {
    var _module: BaseModule! { get set }
    func setModule(module: BaseModule)
}

open class BaseView: UIViewController, BaseViewProtocol {
    public var _module: BaseModule!
    
    public func setModule(module: BaseModule) {
        _module = module
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        _module._presenter.viewHasLoaded()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _module._presenter.viewIsAboutToAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _module._presenter.viewHasAppeared()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _module._presenter.viewIsAboutToDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _module._presenter.viewHasDisappeared()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _module._presenter.prepare(for: segue, sender: sender)
    }
}
