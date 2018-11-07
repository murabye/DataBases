//
//  textCell.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class textCell: UITableViewCell, dataCellsProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var maxLenght: Int32 = Int32.max
    
    func getType() -> columnType {
        return columnType.text
    }
    
    func getData() -> (data: String, type: columnType) {
        return (textField.text!, getType())
    }
    
    func set(data: String, type: columnType) {
        textField.text = data
    }
    
    func set(interactionEnabled: Bool) {
        textField.isUserInteractionEnabled = interactionEnabled
    }
    
    func set(mask: maskModel) {
        maxLenght = mask.max_length!
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int32(textField.text!.count) < maxLenght {
            return false
        }
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
