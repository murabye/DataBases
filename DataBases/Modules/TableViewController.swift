//
//  TableViewController.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var dataModel: [[(data: Any?, type: ColumnType, columnName: String)]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataModel = SqlManager.shared.getData(withId: SqlManager.shared.selectedTableId)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataModel[indexPath.section][indexPath.row].columnName == "id"{
            return 0
        }
        return 44
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)

        cell.textLabel?.text = dataModel[indexPath.section][indexPath.row].columnName
        
        if dataModel[indexPath.section][indexPath.row].data! is String{
            cell.detailTextLabel?.text = dataModel[indexPath.section][indexPath.row].data! as? String
        }
        else if dataModel[indexPath.section][indexPath.row].data! is Int32{
            cell.detailTextLabel?.text = String(dataModel[indexPath.section][indexPath.row].data! as! Int32)
        }
        else if dataModel[indexPath.section][indexPath.row].data! is Bool{
            cell.detailTextLabel?.text = (dataModel[indexPath.section][indexPath.row].data! as! Bool) ? "Да" : "Нет"
        }
        cell.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить секцию") {
            _, indexPath in
            self.dataModel.remove(at: indexPath.section)
            for column in self.dataModel[indexPath.section]{
                if column.columnName == "id"{
                    SqlManager.shared.deleteData(fromTableWithId: SqlManager.shared.selectedTableId, dataId: column.data as! Int32)
                }
            }
            tableView.deleteSections([indexPath.section], with: .automatic)
        }
        return [deleteAction]
    }
}
