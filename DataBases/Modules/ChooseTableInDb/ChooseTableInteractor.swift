//
//  ChooseTableInteractor.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - ChooseTableInteractor Class
final class ChooseTableInteractor: BaseInteractor {
}

// MARK: - ___VARIABLE_ViperitModuleName___Interactor Protocol
extension ChooseTableInteractor: ChooseTableInteractorProtocol {
    // TODO:
    func getTableList() -> [String] {
        return []
    }
    
}

// MARK: - Interactor Viper Components Protocol
private extension ChooseTableInteractor {
    var presenter: ChooseTablePresenterProtocol {
        return module.presenter
    }
    var module: ChooseTableModule {
        return _module as! ChooseTableModule
    }
}