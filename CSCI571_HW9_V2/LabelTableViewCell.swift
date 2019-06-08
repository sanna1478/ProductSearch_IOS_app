//
//  LabelTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/25/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
