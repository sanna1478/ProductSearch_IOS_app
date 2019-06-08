//
//  WishListableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/23/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class WishListableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPostCode: UILabel!
    @IBOutlet weak var itemCondition: UILabel!
    @IBOutlet weak var itemShippingPrice: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
