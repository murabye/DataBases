//
//  ChooseDbScreenTableVM.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ChooseDbScreenDisplayData class
final class ChooseDbScreenTableViewModel: BaseTableViewModel {

    var databaseList:[(Int32, String)] = []
    
    //MARK: DataSource
    override func number(ofRowsInSection section: Int, tableView: UITableView) -> Int {
        if section == 0 {
            return databaseList.count
        }
        return 1
    }
    override func cell(forRow row: Int, section: Int, tableView: UITableView) -> UITableViewCell {
        switch section {
        case 0:
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = databaseList[row].1
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            return cell!
        }
    }
    override func number(ofSections tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Delegate
    override func did(selectRow row: Int, section: Int, tableView: UITableView) {
        presenter.selectTable(index: row)
    }
    override func height(forRow row: Int, section: Int, tableView: UITableView) -> CGFloat {
        return 44
    }
    
    var presenter: ChooseDbScreenPresenterApi {
        return self._module._presenter as! ChooseDbScreenPresenterApi
    }
}
