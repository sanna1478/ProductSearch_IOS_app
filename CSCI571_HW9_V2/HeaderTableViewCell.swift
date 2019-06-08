//
//  HeaderTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/24/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
