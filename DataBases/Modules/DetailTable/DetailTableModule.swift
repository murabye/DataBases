//
//  DetailTableModule.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: DetailTableModule Class
final class DetailTableModule: BaseModule {
}

//MARK: - DetailTableModule Components
extension DetailTableModule {

    var presenter: DetailTablePresenterProtocol {
        return self._presenter as! DetailTablePresenterProtocol
    }
    var interactor: DetailTableInteractorProtocol {
        return self._interactor as! DetailTableInteractorProtocol
    }
    var view: DetailTableViewProtocol {
        return self._view as! DetailTableViewProtocol
    }
    var router: DetailTableRouterProtocol {
        return self._router as! DetailTableRouterProtocol
    }
    var tableViewModel: DetailTableTableViewModel {
        return self._tableViewModel as! DetailTableTableViewModel
    }
}
