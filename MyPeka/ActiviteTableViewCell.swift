//
//  ActiviteTableViewCell.swift
//  MyPeka
//
//  Created by Polytech on 12/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class ActiviteTableViewCell: UITableViewCell {

    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
