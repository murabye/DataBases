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
    var dbList: [(Int32, String)] = []
}

// MARK: - ___VARIABLE_ViperitModuleName___Interactor API
extension ChooseDbScreenInteractor: ChooseDbScreenInteractorApi {
    func getDatabaseList() -> [(Int32, String)] {
        // TODO:
        dbList = SqlManager.shared.getDatabaseList()
        return dbList;
    }
    func createNewDB(name: String) {
        SqlManager.shared.addDatabase(name)
    }
    
    func selectDB(index: Int) {
        SqlManager.shared.setSelectedDb(toId: dbList[index].0)
    }
    
    func deleteTable(index: Int) {
        SqlManager.shared.deleteDataBase(withId: dbList[index].0)
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
