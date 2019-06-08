//
//  EbayTableViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/21/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

protocol returnDataProtocol: AnyObject {
    func returnData(_ wishlist: Dictionary<String, Ebay>, _ formData: Form)
}

class EbayTableViewController: UITableViewController {
    
    var form = Form()
    var wishList: [String:Ebay] = [:]

    let cellIdentifier = "EbayTableViewCell"
    
    @IBOutlet var searchResultView: UITableView!
    weak var delegate: returnDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.getSearchResult(self.tableView)
        
        // Need to make HTTP call to get ebay data
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.returnData(wishList,form)
        }
    }
    
    func test() {
        print("Hello")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if form.finishedHttpRequest == true{
            if form.ebayItems.count == 0 {
                raiseAlert()
            }
            form.finishedHttpRequest = false
        }
        return form.ebayItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EbayTableViewCell
        
        cell?.wishlistButtonActionAdd = { [unowned self] in
            let key = self.form.ebayItems[indexPath.row].itemId
            self.form.ebayItems[indexPath.row].WishList = true
            self.wishList[key!] = self.form.ebayItems[indexPath.row]
            let title = self.form.ebayItems[indexPath.row].title
            self.view.makeToast(title! + " was added to the wishList", duration:2.0, position: .bottom)
        }
        
        cell?.wishlistButtonActionRemove = { [unowned self] in
            let key = self.form.ebayItems[indexPath.row].itemId
            self.form.ebayItems[indexPath.row].WishList = false
            let title = self.form.ebayItems[indexPath.row].title
            self.wishList.removeValue(forKey: key!)
            self.view.makeToast(title! + " was removed from wishList", duration:2.0, position: .bottom)
        }
        
        let item = form.ebayItems[indexPath.row]
        if item.itemImage == nil {
            let url = URL(string: item.galleryURL!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                form.ebayItems[indexPath.row].itemImage = image
            }
        }
        
        // Configure the cell...
        cell?.ItemImage.image = item.itemImage
        cell?.ItemTitle.text = item.title
        cell?.ItemCondition.text = item.condition
        cell?.ItemPrice.text = "$"+item.price!
        cell?.ItemPostCode.text = item.postalCode
        if item.shippingPrice != "FREE SHIPPING" && item.shippingPrice != nil {
            cell?.ItemShipping.text = "$"+item.shippingPrice!
        } else {
            cell?.ItemShipping.text = item.shippingPrice
        }
        cell?.ItemCondition.text = item.condition
        cell?.setCell(self.form.ebayItems[indexPath.row], self.wishList)
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "SearchToInfo", sender: cell)
    }
    
    func raiseAlert() {
        let alert = UIAlertController(title: "No Results!", message: "Failed to fetch search results", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {_ -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateInitialViewController()
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(nextViewController!, animated: false, completion: nil)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true) {}
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let tabBarController = segue.destination as? TabBarViewController {
            tabBarController.form = self.form
            tabBarController.wishList = self.wishList
            
            if let cell = sender as? EbayTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                tabBarController.ebayItem = self.form.ebayItems[indexPath.row]
                tabBarController.wishList = self.wishList
                tabBarController.form = self.form
            }
            
            // TODO: may need to delegate self
            tabBarController.updateFormAndWishList = { [weak self] form, wishList in
                self?.form = form
                self?.wishList = wishList
                self?.searchResultView.reloadData()
            }
        }
    }
}

