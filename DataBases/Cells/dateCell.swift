//
//  dateCell.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class dateCell: UITableViewCell, dataCellsProtocol {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    func getType() -> columnType {
        return columnType.text
    }
    
    func getData() -> (data: String, type: columnType) {
        return (datePicker.date.description, getType())
    }
    
    func set(data: String, type: columnType) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: data)
        if let date = date {
            datePicker.setDate(date, animated: true)
        }
    }
    
    func set(interactionEnabled: Bool) {
        datePicker.isUserInteractionEnabled = interactionEnabled
    }
    
    func set(mask: maskModel) {
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
