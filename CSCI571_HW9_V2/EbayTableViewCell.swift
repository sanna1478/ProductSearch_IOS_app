//
//  EbayTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/21/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class EbayTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemTitle: UILabel!
    @IBOutlet weak var ItemCondition: UILabel!
    @IBOutlet weak var ItemPostCode: UILabel!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var ItemShipping: UILabel!
    @IBOutlet weak var WishListButton: UIButton!
    
    var wishlistButtonActionAdd: (() -> ())?
    var wishlistButtonActionRemove: (() -> ())?
    var wishListPressed = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.WishListButton.addTarget(self, action: #selector(WishListButtonTapped(_:)), for: .touchUpInside)
    }

    @IBAction func WishListButtonTapped(_ sender: UIButton) {
        if wishListPressed == false {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"wishListFilled"), for: UIControl.State.normal)
            
                // Fade in new image
                UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            wishlistButtonActionAdd?()
            wishListPressed = true
        } else {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"wishListEmpty"), for: UIControl.State.normal)
                
                // Fade in new image
                UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            wishlistButtonActionRemove?()
            wishListPressed = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ item: Ebay, _ wishlist: Dictionary<String, Ebay>) {
        if wishlist[item.itemId!] != nil {
            self.WishListButton.setImage(UIImage(named:"wishListFilled"), for: UIControl.State.normal)
            wishListPressed = true
        } else {
            self.WishListButton.setImage(UIImage(named:"wishListEmpty"), for: UIControl.State.normal)
            wishListPressed = false
        }
    }
}

