//
//  relationModel.swift
//  DataBases
//
//  Created by варя on 06/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

struct RelationModel {
    enum relationType:Int32 {
        case oneToOne = 1
        case oneToMore = 2
        case oneToOneOrNull = 4
        case oneToMoreOrNull = 5
    }
    
    // name of распределительная table: system_table1_table2
    let id_table1: Int32// = 0
    let id_table2: Int32// = 0
    // TODO: fix in db
    let relation_type: Int32// = 0
    let name: String// = ""
    //let name: String = ""
}
