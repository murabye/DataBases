//
//  CreateTableStringViewController.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class CreateTableStringViewController: UITableViewController {

    var modelsList: [(ColumnType, String)] = SqlManager.shared.getColumnList(forTableId: SqlManager.shared.selectedTableId)
    var cellArray: [dataCellsProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelsList = SqlManager.shared.getColumnList(forTableId: SqlManager.shared.selectedTableId)
        for model in modelsList{
            let cell = tableView.dequeueReusableCell(withIdentifier: Helper.identifierCellAt(type: model.0)) as! dataCellsProtocol
            cell.set(data: model.1, type: model.0)
        }
            
    }
    // MARK: - Actions
    @IBAction func createAction(_ sender: Any) {
        var dictionary: Dictionary<String, Any> = [:]
        for i in 0..<cellArray.count {
            let data = cellArray[i].getData().data
            let type = cellArray[i].getData().type
            let name = modelsList[i].1
            dictionary[name] = Helper.getData(from: data, type: type)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellArray[indexPath.row] as! UITableViewCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
