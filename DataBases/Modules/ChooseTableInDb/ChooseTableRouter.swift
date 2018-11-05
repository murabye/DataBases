//
//  ChooseTableRouter.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - ChooseTableRouter class
final class ChooseTableRouter: BaseRouter {
}

// MARK: - ChooseTableRouter Protocol
extension ChooseTableRouter: ChooseTableRouterProtocol {
    // TODO
    func gotoTableModule() -> ChooseDbScreenModule {
        return ChooseDbScreenModule()
    }
    
    func gotoCreateTableModule() -> ChooseDbScreenModule {
        return ChooseDbScreenModule()
    }
    
}

// MARK: - ChooseTable Viper Components
private extension ChooseTableRouter {
    var module: ChooseTableModule {
        return _module as! ChooseTableModule
    }
    var presenter: ChooseTablePresenterProtocol {
        return module.presenter
    }
}
