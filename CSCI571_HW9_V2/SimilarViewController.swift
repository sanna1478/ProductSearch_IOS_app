//
//  SimilarViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/25/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class SimilarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var SimilarCollection: UICollectionView!
    var form = Form()
    var wishList: [String:Ebay] = [:]
    var ebayItem = Ebay()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabViewCtrl = tabBarController as! TabBarViewController
        self.form = tabViewCtrl.form
        self.wishList = tabViewCtrl.wishList
        self.ebayItem = tabViewCtrl.ebayItem
        
        SimilarCollection.delegate = self
        SimilarCollection.dataSource = self
        
        form.getSimilarItems(ebayItem, SimilarCollection)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return form.ebaySimilarItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCell", for: indexPath) as? SimilarCollectionViewCell)
        
        let url = URL(string: form.ebaySimilarItem[indexPath.row].imgURL!)
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let img = UIImage(data: imageData)
            cell?.ItemImage.image = img
        }
        cell?.ItemPrice.text = form.ebaySimilarItem[indexPath.row].price
        cell?.shipping.text = form.ebaySimilarItem[indexPath.row].shippingCost
        return cell!
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
