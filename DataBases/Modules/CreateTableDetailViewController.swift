 //
//  CreateTableDetailViewController.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class CreateTableDetailViewController: UITableViewController {

    let tableArray = SqlManager.shared.getTableList(forDbId: SqlManager.shared.connectedDataBaseId)
    var selectedTable: (Int32, String)?
    let createTableViewController: CreateTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func createAction(_ sender: Any) {
        if let selectedTable = selectedTable {
            createTableViewController?.createColumnWithTableId(tableID: selectedTable.0)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tableArray[indexPath.row].1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTable = tableArray[indexPath.row]
    }

}
