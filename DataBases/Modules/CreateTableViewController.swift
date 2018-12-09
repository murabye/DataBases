//
//  CreateTableViewController.swift
//  
//
//  Created by Владимир on 09/12/2018.
//

import UIKit

class CreateTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var columnNameField: UITextField!
    @IBOutlet weak var dataTypeSegment: UISegmentedControl!
    @IBOutlet weak var uniqueSwitch: UISwitch!
    @IBOutlet weak var notNullSwitch: UISwitch!
    @IBOutlet weak var keySwitch: UISwitch!
    
    var columnArray: [columnModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //MARK: - Actions
    
    @IBAction func uniqueSwitchAction(_ sender: Any) {
    }
    @IBAction func notNullSwitchAction(_ sender: Any) {
    }
    @IBAction func keySwitchAction(_ sender: Any) {
    }
    @IBAction func segmentChange(_ sender: Any) {
    }
    
    @IBAction func createColumnAction(_ sender: Any) {
        if dataTypeSegment.selectedSegmentIndex == 4 {
            
        }
        
    }
    @IBAction func createTableAction(_ sender: Any) {
    }
    
    // MARK: - Helpers
    
    func createColumnWithTableId(tableID: Int32){
        
    }
    
    func getNameAt(columnType: columnType) -> String{
        switch columnType {
        case .bool:
            return "Да/Нет"
        case .date:
            return "Дата"
        case .id:
            return "Ссылка"
        case .integer:
            return "Число"
        default:
            return "Текст"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return columnArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = columnArray[indexPath.row].name
        cell.detailTextLabel?.text = getNameAt(columnType: columnArray[indexPath.row].type)
        return cell
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
