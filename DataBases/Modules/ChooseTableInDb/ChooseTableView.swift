//
//  ChooseTableView.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: ChooseTableView Class
final class ChooseTableView: BaseTableView {
    @IBAction func AddTableAction(_ sender: Any) {
        presenter.CreateTable()
    }
}

//MARK: - ChooseTableView Protocol
extension ChooseTableView: ChooseTableViewProtocol {
    var table: UITableView {
        return tableView
    }
}

// MARK: - ChooseTableView Viper Components Protocol
private extension ChooseTableView {
    var module: ChooseTableModule {
        return _module as! ChooseTableModule
    }
    var presenter: ChooseTablePresenterProtocol {
        return module.presenter
    }
}
