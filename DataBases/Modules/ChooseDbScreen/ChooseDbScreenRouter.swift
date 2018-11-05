//
//  ChooseDbScreenRouter.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ChooseDbScreenRouter class
final class ChooseDbScreenRouter: BaseRouter {
}

// MARK: - ChooseDbScreenRouter API
extension ChooseDbScreenRouter: ChooseDbScreenRouterApi {
    func gotoSelectTableModule() -> ChooseDbScreenModule {
        return ChooseDbScreenModule()
    }
    
    func gotoCreateDbModule() -> CreateDbView {
        let sb = UIStoryboard.init(name: "CreateDbView", bundle: .main)
        let vc = sb.instantiateInitialViewController()
        view.navigationController?.pushViewController(vc!, animated: true)
        return vc as! CreateDbView

    }
    
}

// MARK: - ChooseDbScreen Viper Components
private extension ChooseDbScreenRouter {
    var presenter: ChooseDbScreenPresenterApi {
        return module.presenter
    }
    var module: ChooseDbScreenModule {
        return _module as! ChooseDbScreenModule
    }
}
