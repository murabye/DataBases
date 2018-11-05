//
//  ChooseTableModuleProtocols.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//


//MARK: - ChooseTableRouter Protocol
protocol ChooseTableRouterProtocol: BaseRouterProtocol {
    func gotoTableModule() -> ChooseDbScreenModule
    func gotoCreateTableModule() -> ChooseDbScreenModule
}

//MARK: - ChooseTableView Protocol
protocol ChooseTableViewProtocol: BaseViewProtocol {
    var table: UITableView { get }
}

//MARK: - ChooseTablePresenter Protocol
protocol ChooseTablePresenterProtocol: BasePresenterProtocol {
    func CreateTable()
    func SelectTable(index: Int)
}

//MARK: - ChooseTableInteractor Protocol
protocol ChooseTableInteractorProtocol: BaseInteractorProtocol {
    func getTableList() -> [String]
}
