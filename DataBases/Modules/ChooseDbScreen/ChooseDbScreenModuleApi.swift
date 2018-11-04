//
//  ChooseDbScreenModuleApi.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//


//MARK: - ChooseDbScreenRouter API
protocol ChooseDbScreenRouterApi: BaseRouterProtocol {
    // TODO:
    func gotoSelectTableModule() -> ChooseDbScreenModule
    func gotoCreateDbModule() -> ChooseDbScreenModule
}

//MARK: - ChooseDbScreenView API
protocol ChooseDbScreenViewApi: BaseViewProtocol {
    var table: UITableView { get }
}

//MARK: - ChooseDbScreenPresenter API
protocol ChooseDbScreenPresenterApi: BasePresenterProtocol {
    func CreateDb()
    func SelectTable(index: Int)
}

//MARK: - ChooseDbScreenInteractor API
protocol ChooseDbScreenInteractorApi: BaseInteractorProtocol {
    func getDatabaseList() -> [String]
}
