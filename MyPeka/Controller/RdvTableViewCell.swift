//
//  RdvTableViewCell.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class RdvTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var docteurLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
