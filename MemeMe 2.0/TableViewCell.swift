//
//  TableViewCell.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 7/23/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var memeThumbnail: UIImageView!
    @IBOutlet weak var topBottomDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
