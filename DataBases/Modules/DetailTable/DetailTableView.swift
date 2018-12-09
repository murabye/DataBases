//
//  DetailTableView.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//Copyright © 2018 варя. All rights reserved.
//

import UIKit

//MARK: DetailTableView Class
final class DetailTableView: BaseTableView {
}

//MARK: - DetailTableView Protocol
extension DetailTableView: DetailTableViewProtocol {
}

// MARK: - DetailTableView Viper Components Protocol
private extension DetailTableView {
    var module: DetailTableModule {
        return _module as! DetailTableModule
    }
    var presenter: DetailTablePresenterProtocol {
        return module.presenter
    }
}
