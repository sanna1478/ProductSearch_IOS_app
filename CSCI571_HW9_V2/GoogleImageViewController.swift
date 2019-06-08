//
//  GoogleImageViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/25/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class GoogleImageViewController: UIViewController, UIScrollViewDelegate {
    var form = Form()
    var wishList: [String:Ebay] = [:]
    var ebayItem = Ebay()
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    @IBOutlet weak var googleImages: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabViewCtrl = tabBarController as! TabBarViewController
        self.form = tabViewCtrl.form
        self.wishList = tabViewCtrl.wishList
        self.ebayItem = tabViewCtrl.ebayItem
        
        form.getGoogleImages(ebayItem) { (result) -> () in
            let images = result
            print(images.count)
            for index in 0..<images.count {
                self.frame.origin.y = 300 * CGFloat(index)
                self.frame.size = self.googleImages.frame.size
                
                let imageView = UIImageView(frame: self.frame)
                let url = URL(string: images[index])
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let img = UIImage(data: imageData)
                    imageView.image = img
                    self.googleImages.addSubview(imageView)
                }
            }
            self.googleImages.contentSize = CGSize(width: self.googleImages.frame.size.width, height: 300 * CGFloat(images.count))
            self.googleImages.delegate = self
            self.googleImages.isPagingEnabled = false
            self.googleImages.showsHorizontalScrollIndicator = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
