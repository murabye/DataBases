//
//  CreateTableViewController.swift
//  
//
//  Created by Владимир on 09/12/2018.
//

import UIKit

class CreateTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var createColumnButton: UIButton!
    @IBOutlet weak var columnNameField: UITextField!
    @IBOutlet weak var dataTypeSegment: UISegmentedControl!
    @IBOutlet weak var uniqueSwitch: UISwitch!
    @IBOutlet weak var notNullSwitch: UISwitch!
    @IBOutlet weak var keySwitch: UISwitch!
    @IBOutlet weak var maskSwitch: UISwitch!
    
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
    
    @IBAction func columnNameChangedAction(_ sender: Any) {
        createColumnButton.isEnabled = (columnNameField.text ?? "") != ""
    }
    @IBAction func columnNameChangedEditingAction(_ sender: Any) {
        createColumnButton.isEnabled = (columnNameField.text ?? "") != ""
    }
    
    @IBAction func uniqueSwitchAction(_ sender: Any) {
    }
    @IBAction func notNullSwitchAction(_ sender: Any) {
    }
    @IBAction func keySwitchAction(_ sender: Any) {
    }
    @IBAction func segmentChange(_ sender: Any) {
        switch dataTypeSegment.selectedSegmentIndex {
        case 3:
            keySwitch.isEnabled = false
            uniqueSwitch.isEnabled = false
            notNullSwitch.isEnabled = false
            maskSwitch.isEnabled = false
        case 2:
            maskSwitch.isEnabled = false
        default:
            keySwitch.isEnabled = true
            uniqueSwitch.isEnabled = true
            notNullSwitch.isEnabled = true
            maskSwitch.isEnabled = true
        }
    }
    
    @IBAction func createColumnAction(_ sender: Any) {
        guard let name = columnNameField.text else {
            showAlert(withMessage: "Имя некорректно!")
            return
        }
        
        guard name != "" else {
            showAlert(withMessage: "Имя некорректно!")
            return
        }
        
        for column in columnArray {
            if column.name == name {
                showAlert(withMessage: "Имя уже занято!")
                return
            }
        }
        for relation in relationArray {
            if relation.name == name {
                showAlert(withMessage: "Имя уже занято!")
                return
            }
        }
        
        if maskSwitch.isOn {
            if dataTypeSegment.selectedSegmentIndex == 0 {
                let alert = UIAlertController(title: "Маска", message: "Введите максимально допустимую длину вводимого текста", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Принять", style: .default) { (_) -> Void in
                    let nameField = alert.textFields?[0]
                    
                    if let maskText = nameField?.text {
                        let mask = MaskModel.init(min_value: nil, max_value: nil, max_length: Int32(maskText)!)
                        let columnModel = ColumnModel.init(id_table: 0,
                                                           name: name,
                                                           type: self.getTypeAt(segmentSelectedIndex: self.dataTypeSegment.selectedSegmentIndex),
                                                           mask: mask,
                                                           isUnique: self.uniqueSwitch.isOn,
                                                           not_null: self.notNullSwitch.isOn,
                                                           primary_key: self.keySwitch.isOn)
                        
                        self.columnArray.append(columnModel)
                        self.columnNameField.text = ""
                        self.keySwitch.isOn = false
                        self.uniqueSwitch.isOn = false
                        self.notNullSwitch.isOn = false
                        self.maskSwitch.isOn = false
                        self.tableView.reloadData()
                    }
                
                }
                
                alert.addTextField { (_) -> Void in }
                alert.textFields![0].text = "10"
                alert.textFields![0].keyboardType = .numberPad
                
                alert.addAction(saveAction)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Маска", message: "Введите минимальное и максимальное значение", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Принять", style: .default) { (_) -> Void in
                    let minField = alert.textFields?[0]
                    let maxField = alert.textFields?[1]
                    
                    if let minText = minField?.text {
                        if let maxText = maxField?.text {
                            let mask = MaskModel.init(min_value: Int32(minText)!, max_value: Int32(maxText)!, max_length: nil)
                            let columnModel = ColumnModel.init(id_table: 0,
                                                               name: name,
                                                               type: self.getTypeAt(segmentSelectedIndex: self.dataTypeSegment.selectedSegmentIndex),
                                                               mask: mask,
                                                               isUnique: self.uniqueSwitch.isOn,
                                                               not_null: self.notNullSwitch.isOn,
                                                               primary_key: self.keySwitch.isOn)
                            
                            self.columnArray.append(columnModel)
                            self.columnNameField.text = ""
                            self.keySwitch.isOn = false
                            self.uniqueSwitch.isOn = false
                            self.notNullSwitch.isOn = false
                            self.maskSwitch.isOn = false
                            self.tableView.reloadData()
                        }
                    }
                }
                
                alert.addTextField { (_) -> Void in }
                alert.textFields![0].text = "0"
                alert.textFields![0].keyboardType = .numberPad
                
                alert.addTextField { (_) -> Void in }
                alert.textFields![1].text = "999"
                alert.textFields![1].keyboardType = .numberPad
                
                alert.addAction(saveAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        guard dataTypeSegment.selectedSegmentIndex != 3 else {
            self.performSegue(withIdentifier: "showAllTables", sender: nil)
            return
        }
        
        let columnModel = ColumnModel.init(id_table: 0,
                                 name: name,
                                 type: getTypeAt(segmentSelectedIndex: dataTypeSegment.selectedSegmentIndex),
                                 mask: nil,
                                 isUnique: uniqueSwitch.isOn,
                                 not_null: notNullSwitch.isOn,
                                 primary_key: keySwitch.isOn)
        
        columnArray.append(columnModel)
        self.columnNameField.text = ""
        self.keySwitch.isOn = false
        self.uniqueSwitch.isOn = false
        self.notNullSwitch.isOn = false
        self.maskSwitch.isOn = false
        tableView.reloadData()
    }
    
    @IBAction func createTableAction(_ sender: Any) {
        guard let name = nameField.text else {
            showAlert(withMessage: "Имя некорректно!")
            return
        }
        guard name != "" else {
            showAlert(withMessage: "Имя некорректно!")
            return
        }
        
        let tablesInDB = SqlManager.shared.getTableList(forDbId: SqlManager.shared.connectedDataBaseId)
        
        for table in tablesInDB {
            if table.1 == name {
                showAlert(withMessage: "Имя таблицы уже занято!")
                return
            }
        }
        
        let db = SqlManager.shared.connectedDataBaseId
        SqlManager.shared.addTable(name, toDb: db, withColumns: columnArray, andRelations: relationArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    func createColumnWithTableId(tableID: Int32, relationType: Int32){
        let relationModel = RelationModel.init(id_table1: 0,
                                               id_table2: tableID,
                                               relation_type: relationType,
                                               name: columnNameField.text!)
        relationArray.append(relationModel)
        tableView.reloadData()
    }
    
    func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: message, message:
            nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        self.present(alertController, animated: true, completion: nil)
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
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
            cell.detailTextLabel?.text = getNameAt(ColumnType: columnArray[indexPath.row].type) + (columnArray[indexPath.row].primary_key ? " : Ключевой" : "")
        } else {
            cell.textLabel?.text = relationArray[indexPath.row].name
            cell.detailTextLabel?.text = getNameAt(ColumnType: .id)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && columnArray.count > 0 {
            return "Столбцы"
        } else if section == 1 && relationArray.count > 0 {
            return "Связи"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
            _, indexPath in
            if indexPath.section == 0 {
                self.columnArray.remove(at: indexPath.row)
            } else {
                self.relationArray.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllTables"{
            let vc = segue.destination as! CreateTableDetailViewController
            vc.createTableViewController = self
        }
    }

}
