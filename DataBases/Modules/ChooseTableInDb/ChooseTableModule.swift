//
//  ChooseTableModule.swift
//  DataBases
//
//  Created by варя on 05/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: ChooseTableModule Class
final class ChooseTableModule: BaseModule {
}

//MARK: - ChooseTableModule Components
extension ChooseTableModule {

    var presenter: ChooseTablePresenterProtocol {
        return self._presenter as! ChooseTablePresenterProtocol
    }
    var interactor: ChooseTableInteractorProtocol {
        return self._interactor as! ChooseTableInteractorProtocol
    }
    var view: ChooseTableViewProtocol {
        return self._view as! ChooseTableViewProtocol
    }
    var router: ChooseTableRouterProtocol {
        return self._router as! ChooseTableRouterProtocol
    }
    var tableViewModel: ChooseTableTableViewModel {
        return self._tableViewModel as! ChooseTableTableViewModel
    }
}
