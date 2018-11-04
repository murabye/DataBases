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
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        let module = AppModules.ChooseDbScreen.build()
        self._module = module
        super.viewDidLoad()
        module.change(view: self)
    }
}

//MARK: - ChooseDbScreenView API
extension ChooseDbScreenView: ChooseDbScreenViewApi {
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
