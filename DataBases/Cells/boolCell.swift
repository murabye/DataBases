//
//  boolCell.swift
//  DataBases
//
//  Created by Владимир on 07/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class boolCell: UITableViewCell, dataCellsProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    func getType() -> ColumnType {
        return ColumnType.bool
    }
    
    func getData() -> (data: String, type: ColumnType) {
        if switchView.isOn {
            return ("1", getType())
        }
        return ("0", getType())
    }
    
    func set(data: String, type: ColumnType) {
        if type == getType() {
            if data == "1"  {
                switchView.isOn = true
            } else {
                switchView.isOn = false
            }
        }
    }
    
    func set(interactionEnabled: Bool) {
        switchView.isUserInteractionEnabled = interactionEnabled
    }
    
    func set(mask: MaskModel) {
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
