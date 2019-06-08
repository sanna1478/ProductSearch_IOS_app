//
//  TabBarViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/23/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit
import Toast_Swift

class TabBarViewController: UITabBarController {
    
    //Segued Data
    var form = Form()
    var wishList: [String:Ebay] = [:]
    var ebayItem = Ebay()
    
    var dataReady = false
    
    var updateFormAndWishList: ((Form, Dictionary<String, Ebay>) -> Void)?
    
    var wishlistBut: UIImage?
    let shareButImg = UIImage(named: "facebook")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataReady = false
        // Do any additional setup after loading the view.
        if ebayItem.WishList == true {
            wishlistBut = UIImage(named: "wishListFilled")
        } else {
            wishlistBut = UIImage(named: "wishListEmpty")
        }
      
        
        let addButton1 = UIBarButtonItem(image: wishlistBut, style: .plain, target: self, action: #selector(TabBarViewController.WishListUpdate(_:)))
        
        let addButton2 = UIBarButtonItem(image: shareButImg, style: .plain, target: self, action: #selector(callFaceBookApi))
        
        self.navigationItem.rightBarButtonItems = [addButton1, addButton2]
        
    }
    @objc func WishListUpdate(_ sender:UIBarButtonItem!) {
        if ebayItem.WishList == true {
            ebayItem.WishList = false
            self.wishlistBut = UIImage(named: "wishListEmpty")
            sender.image = wishlistBut
            wishList.removeValue(forKey: ebayItem.itemId!)
            for index in 0..<form.ebayItems.count {
                if form.ebayItems[index].itemId == ebayItem.itemId {
                    form.ebayItems[index].WishList = false
                }
            }
            self.view.makeToast(ebayItem.title! + " was removed from wishlist", duration:2.0,position: .bottom)
        } else {
            ebayItem.WishList = true
            self.wishlistBut = UIImage(named: "wishListFilled")
            sender.image = wishlistBut
            wishList[ebayItem.itemId!] = ebayItem
            for index in 0..<form.ebayItems.count {
                if form.ebayItems[index].itemId == ebayItem.itemId {
                    form.ebayItems[index].WishList = true
                    wishList[ebayItem.itemId!] = form.ebayItems[index]
                }
            }
            self.view.makeToast(ebayItem.title! + " was added to the wishList", duration:2.0,position: .bottom)
        }
    }
    @objc func callFaceBookApi() {
        print("TODO")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateFormAndWishList?(self.form, self.wishList)
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
