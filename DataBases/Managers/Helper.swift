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
            return Int32(string)!
        case .integer:
            return Int32(Double(string)!)
        case .text:
            return string
        }
    }
    
    static func showAlert(withMessage message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: message, message:
            nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        viewController.present(alertController, animated: true, completion: nil)
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
    }
}
