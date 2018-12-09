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
    
    var columnArray: [ColumnModel] = []
    var relationArray: [RelationModel] = []
    
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
        guard let name = nameField.text else {
            return
        }
        let columnModel = ColumnModel.init(id_table: 0,
                                 name: name,
                                 type: getTypeAt(segmentSelectedIndex: dataTypeSegment.selectedSegmentIndex),
                                 mask: nil,
                                 unique: uniqueSwitch.isOn,
                                 not_null: notNullSwitch.isOn,
                                 primary_key: keySwitch.isOn)
        
        columnArray.append(columnModel)
    }
    
    @IBAction func createTableAction(_ sender: Any) {
    }
    
    // MARK: - Helpers
    func createColumnWithTableId(tableID: Int32){
        
    }
    
    func getNameAt(ColumnType: ColumnType) -> String{
        switch ColumnType {
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
    func getTypeAt(segmentSelectedIndex: Int) -> ColumnType{
        switch segmentSelectedIndex {
        case 0:
            return .text
        case 1:
            return .integer
        case 2:
            return .bool
        default:
            return .id
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return columnArray.count
        } else {
            return relationArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        if (indexPath.section == 0){
            cell.textLabel?.text = columnArray[indexPath.row].name
            cell.detailTextLabel?.text = getNameAt(ColumnType: columnArray[indexPath.row].type)
        } else {
            cell.textLabel?.text = relationArray[indexPath.row].name
            cell.detailTextLabel?.text = getNameAt(ColumnType: .id)
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllTables"{
            let vc = segue.destination as! CreateTableDetailViewController
            vc.createTableViewController = self
        }
    }

}
