//
//  buttonCell.swift
//  DataBases
//
//  Created by Владимир on 08/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class buttonCell: UITableViewCell, dataCellsProtocol {
    
    @IBOutlet weak var button: UIButton!
    var handler: (() -> ())?
    
    func getType() -> columnType {
        return columnType.integer
    }
    
    func getData() -> (data: String, type: columnType) {
        return ("", getType())
    }
    
    func set(data: String, type: columnType) {
        button.setTitle(data, for: .normal)
        button.setTitle(data, for: .focused)
        button.setTitle(data, for: .highlighted)
        button.setTitle(data, for: .selected)
    }
    
    func set(interactionEnabled: Bool) {
        button.isUserInteractionEnabled = interactionEnabled
    }
    
    func set(mask: maskModel) {
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        if let handler = handler {
            handler()
        }
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
