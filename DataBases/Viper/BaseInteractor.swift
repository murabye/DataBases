//
//  BaseInteractor.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

public protocol BaseInteractorProtocol {
    var _module: BaseModule! { get set }
}

open class BaseInteractor: BaseInteractorProtocol {
    public weak var _module: BaseModule!
    
    required public init() { }
}
