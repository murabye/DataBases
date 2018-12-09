//
//  DetailTableTableViewModel.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation
import UIKit

// MARK: - DetailTableDisplayData class
final class DetailTableTableViewModel: BaseTableViewModel {
    
    //MARK: DataSource
    override func number(ofRowsInSection section: Int, tableView: UITableView) -> Int {
        return 1
    }
    override func cell(forRow row: Int, section: Int, tableView: UITableView) -> UITableViewCell {
        return UITableViewCell.init(style: .default, reuseIdentifier: nil)
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
