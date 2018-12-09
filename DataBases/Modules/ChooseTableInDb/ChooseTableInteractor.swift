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
    var tableList: [(Int32, String)] = []
}

// MARK: - ___VARIABLE_ViperitModuleName___Interactor Protocol
extension ChooseTableInteractor: ChooseTableInteractorProtocol {
    func open(table: Int) {
        
    }
    func selectTable(index: Int) {
        SqlManager.shared.selectedTableId = tableList[index].0
    }
    func getTableList() -> [(Int32, String)] {
        tableList = SqlManager.shared.getTableList(forDbId: SqlManager.shared.connectedDataBaseId)
        return tableList
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
