//
//  ChooseTablePresenter.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation

// MARK: - ChooseTablePresenter Class
final class ChooseTablePresenter: BasePresenter {
    override func viewIsAboutToAppear() {
        tableViewModel.tableList = interactor.getTableList()
        view.table.reloadData()
    }
}

// MARK: - ChooseTablePresenter Protocol
extension ChooseTablePresenter: ChooseTablePresenterProtocol {
    func openTable(atIndex: Int) {
       // interactor.open(table: )
    }
    
    func CreateTable() {
        _ = router.gotoCreateTableModule()
    }
    
    func SelectTable(index: Int) {
        _ = router.gotoTableModule()
    }
    
}

// MARK: - ChooseTable Viper Components
private extension ChooseTablePresenter {
    var view: ChooseTableViewProtocol {
        return module.view
    }
    var interactor: ChooseTableInteractorProtocol {
        return module.interactor
    }
    var router: ChooseTableRouterProtocol {
        return module.router
    }
    var module: ChooseTableModule {
        return _module as! ChooseTableModule
    }
    var tableViewModel: ChooseTableTableViewModel {
        return module.tableViewModel
    }
}
