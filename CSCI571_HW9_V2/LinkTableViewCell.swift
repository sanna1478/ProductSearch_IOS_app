//
//  LinkTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/25/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkTitleValue: UILabel!
    @IBOutlet weak var URLLabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getUrl(_ site: String, _ storeName: String) {
        let hyperlink = NSMutableAttributedString(string: storeName)
        print(storeName)
        
        let url = URL(string: site)
        
        hyperlink.setAttributes([.link: url!], range: NSMakeRange(0, storeName.count))
        
        self.URLLabel.attributedText = hyperlink
        self.URLLabel.isUserInteractionEnabled = true
        self.URLLabel.isEditable = false
        
        self.URLLabel.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        
    }

}
