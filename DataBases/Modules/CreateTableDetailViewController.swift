 //
//  CreateTableDetailViewController.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class CreateTableDetailViewController: UITableViewController {

    @IBOutlet weak var relationSegment: UISegmentedControl!
    let tableArray = SqlManager.shared.getTableList(forDbId: SqlManager.shared.connectedDataBaseId)
    var selectedTable: (Int32, String)?
    var createTableViewController: CreateTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func createAction(_ sender: Any) {
        var relationType = 0
        switch relationSegment!.selectedSegmentIndex {
        case 0:
            relationType = 1
        case 1:
            relationType = 2
        case 2:
            relationType = 4
        case 3:
            relationType = 5
        default:
            relationType = 0
        }
        if let selectedTable = selectedTable {
            createTableViewController?.createColumnWithTableId(tableID: selectedTable.0, relationType: Int32(relationType))
            self.dismiss(animated: true, completion: nil)
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
