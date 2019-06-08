//
//  ViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/19/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit
import McPicker
import Toast_Swift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var form = Form()
    var wishList: [String:Ebay] = [:]
    var wishListKeyArray: [String] = Array()
    
    // Define contextual index
    let new = 0
    let used = 1
    let unspecified = 2
    let pickup = 0
    let freeship = 1
    
    let cellIdentifier = "WishListTableViewCell"
    
    // Define var to stores tableview selection
    var zipCodeIndex = 0
    
    @IBOutlet weak var keywordField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var categoryPicker: McTextField!
    
    @IBOutlet weak var emptyWishListTitle: UILabel!
    @IBOutlet weak var NumItemsLabel: UILabel!
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    @IBOutlet weak var wishTable: UITableView!
    @IBOutlet weak var zipTable: UITableView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    
    @IBOutlet var conditionCheckBoxes: [UIButton]!
    @IBOutlet var shippingCheckBoxes: [UIButton]!
    
    @IBOutlet weak var zipSwitch: UISwitch!
    @IBOutlet weak var searchTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keywordField.delegate = self
        zipcodeField.delegate = self
        distanceField.delegate = self
        
        zipTable.dataSource = self
        zipTable.delegate = self
        wishTable.dataSource = self
        wishTable.delegate = self
        
        self.wishlistView.isHidden = true
        self.zipcodeField.isHidden = true
        self.zipTable.isHidden = true
        
        self.formView.isHidden = false
        
        zipTable.layer.borderColor = UIColor.black.cgColor
        zipTable.layer.borderWidth = 1.0
        
        searchTopConstraint.constant = 20
        clearTopConstraint.constant = 20
        
        // Get the local zipcode of the device
        form.getLocalZip()
        
        let category:[[String]] = [["All","Art","Baby","Books","Clothing,Shoes & Accesories","Computers/Tablets & Networking", "Health & Beauty","Music","Video Games & Consoles"]]
        let mcInputView = McPicker(data: category)
        categoryPicker.inputViewMcPicker = mcInputView
        
        categoryPicker.doneHandler = {[weak categoryPicker] (selections) in
            categoryPicker?.text = selections[0]!
        }
        categoryPicker.cancelHandler = { [weak categoryPicker] in
            categoryPicker?.text = "All"
        }
    }

    @IBAction func customZip(_ sender: UISwitch) {
        if form.customLocation == false {
            form.customLocation = true
            self.zipcodeField.isHidden = false
            searchTopConstraint.constant = 63
            clearTopConstraint.constant = 63
        } else {
            form.customLocation = false
            self.zipcodeField.isHidden = true
            self.zipTable.isHidden = true
            searchTopConstraint.constant = 20
            clearTopConstraint.constant = 20
        }
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            formView.isHidden = false
            wishlistView.isHidden = true
            break
        case 1:
            formView.isHidden = true
            wishlistView.isHidden = false
            updateWishListKeyArray()
            showWishList()
            break
        default:
            break
        }
    }
    
    @IBAction func touchCondition(_ sender: UIButton) {
        let touchedBut = conditionCheckBoxes.firstIndex(of: sender)!
        if form.condition[touchedBut] == false {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"checked"), for: UIControl.State.normal)
                
                // Fade into the new image
                UIButton.animate(withDuration: 0.2, delay:0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            form.condition[touchedBut] = true
        } else {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"unchecked"), for: UIControl.State.normal)
                
                // Fade into the new image
                UIButton.animate(withDuration: 0.2, delay:0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            form.condition[touchedBut] = false
        }
    }
    
    
    @IBAction func touchShipping(_ sender: UIButton) {
        let touchedBut = shippingCheckBoxes.firstIndex(of: sender)!
        if form.shipping[touchedBut] == false {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"checked"), for: UIControl.State.normal)
                
                // Fade into the new image
                UIButton.animate(withDuration: 0.2, delay:0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            form.shipping[touchedBut] = true
        } else {
            UIButton.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                sender.alpha = 0.3
            }, completion: {
                (finished: Bool) -> Void in
                sender.setImage(UIImage(named:"unchecked"), for: UIControl.State.normal)
                
                // Fade into the new image
                UIButton.animate(withDuration: 0.2, delay:0.0, options: .curveEaseIn, animations: {
                    sender.alpha = 1.0
                }, completion: nil)
            })
            form.shipping[touchedBut] = false
        }
    }
    
    @IBAction func getAutoComplete(_ sender: UITextField) {
        form.getCustomZip(sender.text!,zipTable)
    }

    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        if tableView == self.zipTable {
            count = form.customZip.count
        }
        
        if tableView == self.wishTable {
            count = wishList.count
        }
        return count!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.zipTable {
            var cell_zip = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell_zip == nil {
                cell_zip = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            cell_zip?.textLabel?.text = form.customZip[indexPath.row]
            cell = cell_zip
        }
        if tableView == self.wishTable {
            let cell_wish = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WishListableViewCell
            
            let key = wishListKeyArray[indexPath.row]
            let item = wishList[key]
            
            cell_wish?.itemImage.image = item?.itemImage
            cell_wish?.itemTitle.text = item?.title
            cell_wish?.itemCondition.text = item?.condition
            cell_wish?.itemPrice.text = "$"+item!.price!
            cell_wish?.itemPostCode.text = item?.postalCode
            if item?.shippingPrice != "FREE SHIPPING" && item?.shippingPrice != nil {
                cell_wish?.itemShippingPrice.text = "$"+item!.shippingPrice!
            } else {
                cell_wish?.itemShippingPrice.text = item?.shippingPrice
            }
            cell_wish?.itemCondition.text = item?.condition
            
            cell = cell_wish
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.wishTable {
            if editingStyle == .delete {
                let key = wishListKeyArray[indexPath.row]
                wishList.removeValue(forKey: key)
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateWishListKeyArray()
                showWishList()
            }
        }
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.zipTable {
            zipCodeIndex = indexPath.row
            zipcodeField.text = form.customZip[zipCodeIndex]
            form.alienZip = form.customZip[zipCodeIndex]
            zipTable.isHidden = true
        }
        
        if tableView == self.wishTable {
            let cell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "WishToTab", sender: cell)
        }
    }
    
    
    @IBAction func searchOnClick(_ sender: UIButton) {
        form.keyword = keywordField.text
        form.category = categoryPicker.text
        form.dist = distanceField.text
        if form.validateDistance() == false {
            self.view.makeToast("Distance is invalid", duration: 2.0, position: .bottom)
            return
        }
        if form.validateKeyword() == false {
            self.view.makeToast("Keyword is mandatory", duration: 2.0, position: .bottom)
            return
        }
        if form.validateZipCode() == false {
            self.view.makeToast("Zipcode is invalid", duration: 2.0, position: .bottom)
            return
        }
        if form.finalZip?.count == 0 {
            self.view.makeToast("Zipcode is mandatory", duration: 2.0, position: .bottom)
            return
        }
        if shouldPerformSegue(withIdentifier:"FormToSearchResult",sender: self) {
            performSegue(withIdentifier: "FormToSearchResult", sender: self)
        }
    }
    @IBAction func clearOnCLick(_ sender: UIButton) {
        keywordField.text = ""
        zipcodeField.text = ""
        distanceField.text = ""
        distanceField.placeholder = "10"
        categoryPicker.text = "All"
        if zipcodeField.isHidden == false {
            zipcodeField.isHidden = true
            zipSwitch.setOn(false, animated: false)
        }
        for index in 0..<conditionCheckBoxes.count {
            conditionCheckBoxes[index].setImage(UIImage(named:"unchecked"), for: UIControl.State.normal)
            form.condition[index] = false
        }
        for index in 0..<shippingCheckBoxes.count {
            shippingCheckBoxes[index].setImage(UIImage(named:"unchecked"), for: .normal)
        }
        
        form.keyword = nil
        form.category = "All"
        form.dist = "10"
        form.customLocation = false
        form.alienZip = nil
        form.finalZip = form.localZip
        form.customZip.removeAll()
        form.ebayItems.removeAll()
        form.detailedEbayItem = Ebay()
        
    }
    
    func showWishList() {
        if wishList.isEmpty {
            NumItemsLabel.isHidden = true
            TotalPriceLabel.isHidden = true
            wishTable.isHidden = true
            emptyWishListTitle.isHidden = false
        } else {
            emptyWishListTitle.isHidden = true
            NumItemsLabel.isHidden = false
            TotalPriceLabel.isHidden = false
            wishTable.isHidden = false
            updateLabels()
            wishTable.reloadData()
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "FormToSearchResult" {
            return true
        }
        return false
    }
    
    // Prepare to send data when seguing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FormToSearchResult" {
            if let ebayTableViewController = segue.destination as? EbayTableViewController {
                ebayTableViewController.form = self.form
                ebayTableViewController.wishList = self.wishList
                ebayTableViewController.delegate = self
            }
        } else {
            if let tabBarController = segue.destination as? TabBarViewController {
                tabBarController.form = self.form
                tabBarController.wishList = self.wishList
                
                if let cell = sender as? WishListableViewCell, let indexPath = wishTable.indexPath(for: cell) {
                    let key = self.wishListKeyArray[indexPath.row]
                    tabBarController.ebayItem = self.wishList[key]!
                    tabBarController.wishList = self.wishList
                    tabBarController.form = self.form
                }
                
                // TODO: may need to delegate self
                tabBarController.updateFormAndWishList = { [weak self] form, wishList in
                    self?.form = form
                    self?.wishList = wishList
                    self?.updateWishListKeyArray()
                    self?.updateLabels()
                    self?.wishTable.reloadData()
                    self?.showWishList()
                }
            }
        }
    }
    
    func updateLabels() {
        var total = 0.0
        for (_,item) in wishList {
            if let price = item.price {
                total += Double(price)!
            }
        }
        TotalPriceLabel.text = "$"+String(total)
        NumItemsLabel.text = "WishList Total(\(wishList.count) items)"
    }
    
    func updateWishListKeyArray() {
        wishListKeyArray.removeAll()
        for (key,_) in wishList {
            wishListKeyArray.append(key)
        }
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        form.customZip.removeAll()
        return true
    }
}

extension ViewController: returnDataProtocol {
    func returnData(_ wishlist: Dictionary<String, Ebay>, _ formData: Form) {
        self.wishList = wishlist
        self.form = formData
        self.updateWishListKeyArray()
    }
}
