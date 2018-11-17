//
//  CustomCell.swift
//  NFC-Smart-Home
//
//  Created by Joey Cicero on 10/12/17.
//  Copyright © 2017 Garage. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell{
	
    @IBOutlet weak var name: UILabel!
    
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
