//
//  numberCell.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class numberCell: UITableViewCell, dataCellsProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    var maxValue: Int32?
    var minValue: Int32?
    
    @IBAction func stepperTap(_ sender: Any) {
        numberField.text = String(stepper.value) 
    }
    
    func getType() -> ColumnType {
        return ColumnType.integer
    }
    
    func getData() -> (data: String, type: ColumnType) {
        return (numberField.text!, getType())
    }
    
    func set(data: String, type: ColumnType) {
        numberField.placeholder = data
    }
    
    func set(interactionEnabled: Bool) {
        numberField.isUserInteractionEnabled = interactionEnabled
    }
    
    func set(mask: MaskModel) {
        maxValue = mask.max_value!
        stepper.maximumValue = Double(mask.max_value!)
        minValue = mask.min_value!
        stepper.minimumValue = Double(mask.min_value!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if maxValue != nil && minValue != nil {
            if let value = Int32(text) {
                if value > maxValue! || value < minValue! {
                    return false
                }
            }
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
