//
//  dataCellsProtocol.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

protocol dataCellsProtocol {
    func getType() -> ColumnType
    func getData() -> (data: String, type: ColumnType)
    
    func set(data: String, type: ColumnType)
    func set(interactionEnabled: Bool) // = false
    func set(mask: MaskModel)
}
