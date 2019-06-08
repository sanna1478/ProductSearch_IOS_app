//
//  ImageTableViewCell.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/25/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var imageTitleValue: UILabel!
    
    let colorDict = [
        "None": UIColor(red: 0, green: 0, blue: 0, alpha: 0),
        "Yellow": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        "YellowShooting": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        "Blue" : UIColor(red: 0, green: 0, blue: 1, alpha: 1),
        "Turquoise": UIColor(red: 64/255, green: 224/225, blue: 208/255, alpha: 1),
        "TurquoiseShooting": UIColor(red: 64/255, green: 224/225, blue: 208/255, alpha: 1),
        "Purple": UIColor(red: 128/255, green: 0, blue: 128/255, alpha: 1),
        "PurpleShooting": UIColor(red: 128/255, green: 0, blue: 128/255, alpha: 1),
        "Red": UIColor(red: 1, green: 0, blue: 0, alpha: 1),
        "RedShooting": UIColor(red: 1, green: 0, blue: 0, alpha: 1),
        "Green": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        "GreenShooting": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        "SilverShooting":UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setImage(_ color: String, _ feedbackscore: Double) {
        print(color)
        var imgName: String?
        if feedbackscore < 10000 {
            imgName = "starBorder"
        } else {
            imgName = "start"
        }
        let img = UIImage(named: imgName!)
        star.image = img
        
        star.image = star.image?.withRenderingMode(.alwaysTemplate)
        star.tintColor = colorDict[color]
    }

}
