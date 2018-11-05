//
//  ChooseDbScreenView.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: ChooseDbScreenView Class
final class ChooseDbScreenView: BaseTableView {
    override func viewDidLoad() {
        let module = AppModules.ChooseDbScreen.build()
        self._module = module
        super.viewDidLoad()
        module.change(view: self)
    }
    
    @IBAction func addDbButtonAction(_ sender: Any) {
        presenter.CreateDb()
    }
    @IBAction func addDbAction(_ sender: Any) {
        presenter.CreateDb()
    }
}

//MARK: - ChooseDbScreenView API
extension ChooseDbScreenView: ChooseDbScreenViewApi {
    var table: UITableView {
        return tableView
    }
    
}

// MARK: - ChooseDbScreenView Viper Components API
private extension ChooseDbScreenView {
    var module: ChooseDbScreenModule {
        return _module as! ChooseDbScreenModule
    }
    var presenter: ChooseDbScreenPresenterApi {
        return module.presenter
    }
}
