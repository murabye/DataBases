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
        default:
            return ""
        }
    }
}
