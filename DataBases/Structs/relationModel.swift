//
//  relationModel.swift
//  DataBases
//
//  Created by варя on 06/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

struct relationModel {
    enum relationType:Int32 {
        case oneToOne = 1
        case oneToMore
        case MoreToMore
        case oneToOneOrNull
        case oneToMoreOrNull
        case MoreToMoreOrNull
    }
    
    let id_table1: Int32 = 0
    let id_table2: Int32 = 0
    // TODO: fix in db
    let relation_type: Int32 = 0
}
