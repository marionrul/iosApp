//
//  OrdonnanceTableViewCell.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class OrdonnanceTableViewCell: UITableViewCell {

    @IBOutlet weak var NomLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DocteurLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
