//
//  DetailTablePresenter.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - DetailTablePresenter Class
final class DetailTablePresenter: BasePresenter {
}

// MARK: - DetailTablePresenter Protocol
extension DetailTablePresenter: DetailTablePresenterProtocol {
}

// MARK: - DetailTable Viper Components
private extension DetailTablePresenter {
    var view: DetailTableViewProtocol {
        return module.view
    }
    var interactor: DetailTableInteractorProtocol {
        return module.interactor
    }
    var router: DetailTableRouterProtocol {
        return module.router
    }
    var module: DetailTableModule {
        return _module as! DetailTableModule
    }
    var tableViewModel: DetailTableTableViewModel{
        return module.tableViewModel
    }
}
