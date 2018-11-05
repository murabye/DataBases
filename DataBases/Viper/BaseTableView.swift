//
//  BaseTableView.swift
//  MobileAgent
//
//  Created by Вова Петров on 27.09.2018.
//  Copyright © 2018 DartIT. All rights reserved.
//

import UIKit

class BaseTableView: UITableViewController, BaseViewProtocol {
    
    
    public var _module: BaseModule!
    
    public func setModule(module: BaseModule) {
        _module = module
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        _module._presenter.viewHasLoaded()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _module._presenter.viewIsAboutToAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _module._presenter.viewHasAppeared()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _module._presenter.viewIsAboutToDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _module._presenter.viewHasDisappeared()
    }
    
    //MARK: DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.number(ofRowsInSection: section, tableView: tableView)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewModel.cell(forRow: indexPath.row, section: indexPath.section, tableView: tableView)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.number(ofSections: tableView)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewModel.titleForHeader(inSection: section)
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableViewModel.titleForFooter(inSection: section)
    }
    
    //MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewModel.did(selectRow: indexPath.row, section: indexPath.section, tableView: tableView)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewModel.height(forRow: indexPath.row, section: indexPath.section, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableViewModel.did(deselectRow: indexPath.row, section: indexPath.section, tableView: tableView)
    }
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableViewModel.did(deselectRow: indexPath.row, section: indexPath.section, tableView: tableView)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableViewModel.can(editRow: indexPath.row, section: indexPath.section, tableView: tableView)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableViewModel.commit(editing: editingStyle, row: indexPath.row, section: indexPath.section, tableView: tableView)
    }

    
    var tableViewModel: BaseTableViewModelProtocol {
        return _module._tableViewModel
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _module._presenter.prepare(for: segue, sender: sender)
    }
}
