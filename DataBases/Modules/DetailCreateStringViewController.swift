//
//  DetailCreateStringViewController.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class DetailCreateStringViewController: UITableViewController {
    
    var id_table: Int32!
    var cell: buttonCell?
    var dataModel: [[(data: Any?, type: ColumnType, columnName: String)]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = SqlManager.shared.getData(withId: id_table)
    }

    // MARK: - Action
    @IBAction func canselAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.text = dataModel[indexPath.section][indexPath.row].columnName
        
        if dataModel[indexPath.section][indexPath.row].data! is String{
            cell.detailTextLabel?.text = dataModel[indexPath.section][indexPath.row].data! as? String
        }
        
        if dataModel[indexPath.section][indexPath.row].data! is Int32{
            cell.detailTextLabel?.text = String(dataModel[indexPath.section][indexPath.row].data! as! Int32)
        }
        
        if dataModel[indexPath.section][indexPath.row].data! is Bool{
            cell.detailTextLabel?.text = (dataModel[indexPath.section][indexPath.row].data! as! Bool) ? "Да" : "Нет"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for column in dataModel[indexPath.section]{
            if (column.columnName == "id"){
                if column.data! is Int32{
                    cell?.id_table = (column.data! as! Int32)
                    cell?.button.isEnabled = false
                    self.navigationController!.popViewController(animated: true)
                    return
                }
            }
        }
    }
}

