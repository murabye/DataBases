//
//  ChooseTableTableViewModel.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ChooseTableDisplayData class
final class ChooseTableTableViewModel: BaseTableViewModel {
    
    var tableList:[String] = []
    
    //MARK: DataSource
    override func number(ofRowsInSection section: Int, tableView: UITableView) -> Int {
        return tableList.count
    }
    override func cell(forRow row: Int, section: Int, tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tableList[row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    override func number(ofSections tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Delegate
    override func did(selectRow row: Int, section: Int, tableView: UITableView) {
        
    }
    override func height(forRow row: Int, section: Int, tableView: UITableView) -> CGFloat {
        return 44
    }
}
