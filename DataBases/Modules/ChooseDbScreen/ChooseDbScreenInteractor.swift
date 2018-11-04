//
//  ChooseDbScreenInteractor.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - ChooseDbScreenInteractor Class
final class ChooseDbScreenInteractor: BaseInteractor {
}

// MARK: - ___VARIABLE_ViperitModuleName___Interactor API
extension ChooseDbScreenInteractor: ChooseDbScreenInteractorApi {
    func getDatabaseList() -> [String] {
        // TODO:
        return []
    }
    
}

// MARK: - Interactor Viper Components Api
private extension ChooseDbScreenInteractor {
    var presenter: ChooseDbScreenPresenterApi {
        return module.presenter
    }
    var module: ChooseDbScreenModule {
        return _module as! ChooseDbScreenModule
    }
}
