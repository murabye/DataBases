//
//  DetailTableRouter.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - DetailTableRouter class
final class DetailTableRouter: BaseRouter {
}

// MARK: - DetailTableRouter Protocol
extension DetailTableRouter: DetailTableRouterProtocol {
}

// MARK: - DetailTable Viper Components
private extension DetailTableRouter {
    var module: DetailTableModule {
        return _module as! DetailTableModule
    }
    var presenter: DetailTablePresenterProtocol {
        return module.presenter
    }
}
