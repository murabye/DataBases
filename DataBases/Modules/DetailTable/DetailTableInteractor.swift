//
//  DetailTableInteractor.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - DetailTableInteractor Class
final class DetailTableInteractor: BaseInteractor {
}

// MARK: - ___VARIABLE_ViperitModuleName___Interactor Protocol
extension DetailTableInteractor: DetailTableInteractorProtocol {
}

// MARK: - Interactor Viper Components Protocol
private extension DetailTableInteractor {
    var presenter: DetailTablePresenterProtocol {
        return module.presenter
    }
    var module: DetailTableModule {
        return _module as! DetailTableModule
    }
}
