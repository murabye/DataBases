//
//  ChooseTableModuleProtocols.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//


//MARK: - ChooseTableRouter Protocol
protocol ChooseTableRouterProtocol: BaseRouterProtocol {
    func gotoTableModule() -> TableViewController
}

//MARK: - ChooseTableView Protocol
protocol ChooseTableViewProtocol: BaseViewProtocol {
    var table: UITableView { get }
}

//MARK: - ChooseTablePresenter Protocol
protocol ChooseTablePresenterProtocol: BasePresenterProtocol {
    func SelectTable(index: Int)
    
    func openTable(atIndex: Int)
}

//MARK: - ChooseTableInteractor Protocol
protocol ChooseTableInteractorProtocol: BaseInteractorProtocol {
    func getTableList() -> [(Int32, String)]
    func open(table: Int)
    func selectTable(index: Int)
}
