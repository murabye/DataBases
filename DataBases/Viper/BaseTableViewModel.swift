//
//  BaseTableVM.swift
//  VIPER
//
//  Created by Вова Петров on 01.10.2018.
//  Copyright © 2018 Вова Петров. All rights reserved.
//

import UIKit

public protocol BaseTableViewModelProtocol {
    var _module: BaseModule! { get set }
    var title: String? { get set }
    func setTitle(title: String)
    func setModule(module: BaseModule)
    //MARK: DataSource
    func number(ofRowsInSection section: Int, tableView: UITableView) -> Int
    func cell(forRow row: Int, section: Int, tableView: UITableView) -> UITableViewCell
    func number(ofSections tableView: UITableView) -> Int
    func titleForHeader(inSection section: Int) -> String?
    func titleForFooter(inSection: Int) -> String?
    //MARK: Delegate
    func did(selectRow row: Int, section: Int, tableView: UITableView)
    func did(deselectRow row: Int, section: Int, tableView: UITableView)
    func height(forRow row: Int, section: Int, tableView: UITableView) -> CGFloat
    func can(editRow row: Int, section: Int, tableView: UITableView) -> Bool
    func commit(editing editingStyle: UITableViewCell.EditingStyle, row: Int, section: Int, tableView: UITableView)
    
    //MARK: SearchBarDelegate
    func update(searchResult text: String)
}

open class BaseTableViewModel: BaseTableViewModelProtocol {
    public weak var _module: BaseModule!
    public var title: String?
    required public init() { }
    
    public func setTitle(title: String) {
        self.title = title
    }
    //MARK: DataSource
    public func setModule(module: BaseModule) {
        self._module = module
    }
    
    public func number(ofRowsInSection section: Int, tableView: UITableView) -> Int {
        fatalError("function number must be overrided")
    }
    
    public func cell(forRow row: Int, section: Int, tableView: UITableView) -> UITableViewCell {
        fatalError("function cell must be overrided")
    }
    
    public func number(ofSections tableView: UITableView) -> Int {
        return 1
    }
    public func titleForHeader(inSection section: Int) -> String? {
        return nil
    }
    public func titleForFooter(inSection: Int) -> String? {
        return nil
    }
    
    
    //MARK: Delegate
    public func did(selectRow row: Int, section: Int, tableView: UITableView) {
        
    }
    
    public func did(deselectRow row: Int, section: Int, tableView: UITableView) {
        
    }
    
    public func height(forRow row: Int, section: Int, tableView: UITableView) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func can(editRow row: Int, section: Int, tableView: UITableView) -> Bool {
        return false
    }
    public func commit(editing editingStyle: UITableViewCell.EditingStyle, row: Int, section: Int, tableView: UITableView) {
        
    }

    
    //MARK: SearchBarDelegate
    public func update(searchResult text: String) {
        
    }
}
