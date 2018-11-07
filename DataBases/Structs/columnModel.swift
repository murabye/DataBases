//
//  dbColumn.swift
//  DataBases
//
//  Created by варя on 06/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

struct columnModel {
    
    // TODO: узнать, как они называются в sqlite
    enum columnType:String {
        case String
        case Int
        case Bool
        case Double
    }
    
    let id_table:Int32 = 0
    let name:String = ""
    let default_value:String = ""
    let type:String = ""
    var mask:maskModel?
    let unique:Bool = false
    let not_null:Bool = false
    let auto_increment:Bool = false
    let primary_key:Bool = false
}
