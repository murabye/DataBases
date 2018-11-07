//
//  dataCellsProtocol.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

protocol dataCellsProtocol {
    func getType() -> columnType
    func getData() -> (data: String, type: columnType)
    
    func set(data: String, type: columnType)
    func set(interactionEnabled: Bool) // = false
    func set(mask: maskModel)
}
