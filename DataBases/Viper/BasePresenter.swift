//
//  BasePresenter.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//
import UIKit

public protocol BasePresenterProtocol {
    var _module: BaseModule! { get set }
    
    func setupView(data: Any)
    func viewHasLoaded()
    func viewIsAboutToAppear()
    func viewHasAppeared()
    func viewIsAboutToDisappear()
    func viewHasDisappeared()
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

open class BasePresenter: BasePresenterProtocol {
    public weak var _module: BaseModule!
    
    required public init() { }
    
    open func setupView(data: Any) {
        //WARNING: create this
    }
    
    open func viewHasLoaded() {}
    open func viewIsAboutToAppear() {}
    open func viewHasAppeared() {}
    open func viewIsAboutToDisappear() {}
    open func viewHasDisappeared() {}
    open func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
