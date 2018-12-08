//
//  ChooseDbScreenPresenter.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - ChooseDbScreenPresenter Class
final class ChooseDbScreenPresenter: BasePresenter {
}

// MARK: - ChooseDbScreenPresenter API
extension ChooseDbScreenPresenter: ChooseDbScreenPresenterApi {
    func createNewDb(name: String) {
        interactor.createNewDB(name: name)
    }
    
    func CreateDb() {
        
    }
    
    func SelectTable(index: Int) {
        _ = router.gotoSelectTableModule()
    }
    
}

// MARK: - ChooseDbScreen Viper Components
private extension ChooseDbScreenPresenter {
    var view: ChooseDbScreenViewApi {
        return module.view
    }
    var interactor: ChooseDbScreenInteractorApi {
        return module.interactor
    }
    var router: ChooseDbScreenRouterApi {
        return module.router
    }
    var module: ChooseDbScreenModule {
        return _module as! ChooseDbScreenModule
    }
    var tableVM: ChooseDbScreenTableViewModel {
        return module.tableVM
    }
}
