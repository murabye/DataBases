//
//  dbColumn.swift
//  DataBases
//
//  Created by варя on 06/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

// TODO: узнать, как они называются в sqlite
enum columnType:String {
    case text
    case integer
    case bool
    case id
}

struct columnModel {
    
    let id_table: Int32// = 0
    let name: String// = ""
    // TODO: убрать из таблицы let default_value:String = ""
    let type: columnType// = .id
    var mask: maskModel?
    let unique: Bool// = false
    let not_null: Bool// = false
    // TODO: убрать из таблицы let auto_increment:Bool = false
    let primary_key: Bool// = false
}
