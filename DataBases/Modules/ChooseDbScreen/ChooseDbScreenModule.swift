//
//  ChooseDbScreenModule.swift
//  DataBases
//
//  Created by варя on 02/11/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: ChooseDbScreenModule Class
final class ChooseDbScreenModule: BaseModule {
    required init() {
        super.init()
        storyboardName = "Main"
    }
    var presenter: ChooseDbScreenPresenterApi {
        return self._presenter as! ChooseDbScreenPresenterApi
    }
    var interactor: ChooseDbScreenInteractorApi {
        return self._interactor as! ChooseDbScreenInteractorApi
    }
    var view: ChooseDbScreenViewApi {
        return self._view as! ChooseDbScreenViewApi
    }
    var router: ChooseDbScreenRouterApi {
        return self._router as! ChooseDbScreenRouterApi
    }
    var tableVM: ChooseDbScreenTableViewModel {
        return self._tableViewModel as! ChooseDbScreenTableViewModel
    }
}
