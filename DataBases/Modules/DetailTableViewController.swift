//
//  DetailTableViewController.swift
//  DataBases
//
//  Created by Владимир on 16/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet weak var addButton: UIBarButtonItem!
    public var dataModel: [[(data: Any?, type: ColumnType, columnName: String)]]!
    var filteredDataModel: [[(data: Any?, type: ColumnType, columnName: String)]]!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Начните поиск"
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredDataModel = dataModel
        tableView.reloadData()
        searchController.isActive = true
    }
    
    //MARK: - Action
    
    @IBAction func exportAction(_ sender: Any) {
        var exportString = "Отчет о таблице: " + self.title!
        for section in filteredDataModel{
            for row in section {
                var data = ""
                if row.data! is String{
                    data = row.data! as! String
                }
                else if row.data! is Int32{
                    data = String(row.data! as! Int32)
                }
                else if row.data! is Bool{
                    data = (row.data! as! Bool) ? "Да" : "Нет"
                }
                exportString += "\n" + row.columnName + " : " + data
            }
            exportString += "\n-------------------------------------------\n"
        }
        
        
        let activityItems = [exportString]
        let activityController = UIActivityViewController(activityItems: activityItems , applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    // MARK: - SearchUpdater
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredDataModel = dataModel.filter({ (column) -> Bool in
            var contain = false
            for row in column {
                var data = ""
                if row.data! is String{
                    data = row.data! as! String
                }
                else if row.data! is Int32{
                    data = String(row.data! as! Int32)
                }
                else if row.data! is Bool{
                    data = (row.data! as! Bool) ? "Да" : "Нет"
                }
                if let text = searchController.searchBar.text {
                    if text == "" {
                        return true
                    }
                    contain = data.contains(text)
                } else {
                    return true
                }
                if contain {
                    return contain
                }
            }
            return contain
        })
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filteredDataModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredDataModel[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if filteredDataModel[indexPath.section][indexPath.row].columnName == "id"{
            return 0
        }
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.text = filteredDataModel[indexPath.section][indexPath.row].columnName
        
        if filteredDataModel[indexPath.section][indexPath.row].data! is String{
            cell.detailTextLabel?.text = filteredDataModel[indexPath.section][indexPath.row].data! as? String
        }
        else if filteredDataModel[indexPath.section][indexPath.row].data! is Int32{
            cell.detailTextLabel?.text = String(filteredDataModel[indexPath.section][indexPath.row].data! as! Int32)
        }
        else if filteredDataModel[indexPath.section][indexPath.row].data! is Bool{
            cell.detailTextLabel?.text = (filteredDataModel[indexPath.section][indexPath.row].data! as! Bool) ? "Да" : "Нет"
        }
        cell.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить секцию") {
            _, indexPath in
            for column in self.filteredDataModel[indexPath.section]{
                if column.columnName == "id"{
                    SqlManager.shared.deleteData(fromTableWithId: SqlManager.shared.selectedTableId, dataId: column.data as! Int32)
                }
            }
            self.filteredDataModel.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .automatic)
        }
        return [deleteAction]
    }
}
