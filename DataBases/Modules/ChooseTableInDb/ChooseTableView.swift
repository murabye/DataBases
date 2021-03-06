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
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = SqlManager.shared.isAdmin
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard SqlManager.shared.isAdmin else {
            return []
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить таблицу") {
            _, indexPath in
            self.presenter.deleteTable(index: indexPath.row)
            self.table.reloadSections([0], with: .automatic)
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return SqlManager.shared.isAdmin
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
