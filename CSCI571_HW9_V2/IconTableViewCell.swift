//
//  IconTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/24/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleValue: UILabel!
    @IBOutlet weak var TitleName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
