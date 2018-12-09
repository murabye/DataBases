//
//  Helper.swift
//  DataBases
//
//  Created by Владимир on 09/12/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class Helper {
    static func identifierCellAt(type: ColumnType) -> String{
        switch type {
        case .bool:
            return "boolCell"
        case .id:
            return "buttonCell"
        case .integer:
            return "numberCell"
        case .text:
            return "textCell"
        }
    }
    
    static func getData(from string: String, type: ColumnType) -> Any{
        switch type {
        case .bool:
            if string == "0"{
                return false
            } else {
                return true
            }
        case .id:
            return string
        case .integer:
            return Int(string)!
        case .text:
            return string
        }
    }
}
