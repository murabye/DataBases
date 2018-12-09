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
        if dataTypeSegment.selectedSegmentIndex == 3 {
            self.performSegue(withIdentifier: "showAllTables", sender: nil)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columnArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = columnArray[indexPath.row].name
       // cell.detailTextLabel?.text = getNameAt(columnType: columnArray[indexPath.row].type)
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
