//
//  ShippingViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/23/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class ShippingViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var detailItem = Ebay()
    @IBOutlet weak var infoTable: UITableView!
    
    var Sections: [String] = Array()
    var sellerTitles: [String] = Array()
    var returnTitles: [String] = Array()
    var shippingTitles: [String] = Array()
    var sellerValues: [Any] = Array()
    var shippingValues: [String] = Array()
    var returnValues: [String] = Array()
    var sellerInfo: [String:Any] = [:]
    var returnPolicy: [String:String] = [:]
    var shippingInfo: [String:String] = [:]
    
    var feedback = 0.0
    let headerCellIdentifier = "HeaderCell"
    let cellIdentifier = "ContentCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTable.isScrollEnabled = false
        // Do any additional setup after loading the view.
        infoTable.dataSource = self
        infoTable.delegate = self
        
        let tabViewCtrl = tabBarController as! TabBarViewController
        detailItem = tabViewCtrl.ebayItem
        sellerInfo = detailItem.sellerInfo
        returnPolicy = detailItem.returnPolicy
        shippingInfo = detailItem.shippingInfo
        getSections()
        getSectionTitles()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if Sections[section] == "Seller" {
            count = sellerTitles.count
        }
        if Sections[section] == "Shipping" {
            count = shippingTitles.count
        }
        if Sections[section] == "Return Policy" {
            count = returnTitles.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var image: UIImage?
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? HeaderTableViewCell
        if Sections[section] == "Seller" {
            image = UIImage(named: "Seller")
        }
        if Sections[section] == "Shipping" {
            image = UIImage(named: "Shipping Info")
        }
        if Sections[section] == "Return Policy" {
            image = UIImage(named: "Return Policy")
        }
        cell?.titleIcon.image = image
        cell?.titleLabel.text = Sections[section]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }*/
        var cell: UITableViewCell?
        if Sections[indexPath.section] == "Seller" {
            if sellerTitles[indexPath.row] == "Store Name" {
                let cell_link = tableView.dequeueReusableCell(withIdentifier: "ContentLinkCell", for: indexPath) as? LinkTableViewCell
                cell_link?.linkTitleValue.text = sellerTitles[indexPath.row]
                cell_link?.getUrl(sellerValues[indexPath.row] as! String, sellerInfo["Store Name"] as! String)
                cell = cell_link
            } else if sellerTitles[indexPath.row] == "Feedback Star" {
                let cell_image = tableView.dequeueReusableCell(withIdentifier: "ContentImageCell", for: indexPath) as? ImageTableViewCell
                
                cell_image?.imageTitleValue.text = sellerTitles[indexPath.row]
                cell_image?.setImage(sellerValues[indexPath.row] as! String, feedback)
                cell = cell_image
            } else {
                let cell_label = tableView.dequeueReusableCell(withIdentifier: "ContentLabelCell", for: indexPath) as? LabelTableViewCell
                cell_label?.titleValue.text = sellerTitles[indexPath.row]
                cell_label?.valueLabel.text = sellerValues[indexPath.row] as? String
                cell = cell_label
            }
            
            
        }
        if Sections[indexPath.section] == "Shipping" {
            let cell_label = tableView.dequeueReusableCell(withIdentifier: "ContentLabelCell", for: indexPath) as? LabelTableViewCell
            cell_label?.titleValue.text = shippingTitles[indexPath.row]
            cell_label?.valueLabel.text = shippingValues[indexPath.row]
            cell = cell_label
            
        }
        if Sections[indexPath.section] == "Return Policy" {
            let cell_label = tableView.dequeueReusableCell(withIdentifier: "ContentLabelCell", for: indexPath) as? LabelTableViewCell
            cell_label?.titleValue.text = returnTitles[indexPath.row]
            cell_label?.valueLabel.text = returnValues[indexPath.row]
            cell = cell_label
        }
        return cell!
    }
    
    func getSections() {
        if sellerInfo.count > 0 {
            Sections.append("Seller")
        }
        if shippingInfo.count > 0 {
            Sections.append("Shipping")
        }
        if returnPolicy.count > 0 {
            Sections.append("Return Policy")
        }
    }
    
    func getSectionTitles() {
        // Getting titles for Seller
        if sellerInfo["Store Name"] != nil {
            sellerTitles.append("Store Name")
            sellerValues.append(sellerInfo["StoreURL"] as! String)
        }
        if sellerInfo["Feedback Score"] != nil {
            sellerTitles.append("Feedback Score")
            let val = sellerInfo["Feedback Score"] as! Double
            feedback = val
            sellerValues.append(String(val))
        }
        if sellerInfo["Popularity"] != nil {
            sellerTitles.append("Popularity")
            let val = sellerInfo["Popularity"] as! Double
            
            sellerValues.append(String(val))
        }
        if sellerInfo["Feedback Star"] != nil {
            sellerTitles.append("Feedback Star")
            sellerValues.append(sellerInfo["Feedback Star"] as! String)
        }
        
        
        // Getting titles for Shipping
        if shippingInfo["Shipping Cost"] != nil {
            shippingTitles.append("Shipping Cost")
            shippingValues.append("$"+shippingInfo["Shipping Cost"]!)
        }
        if shippingInfo["Global Shipping"] != nil {
            shippingTitles.append("Global Shipping")
            shippingValues.append(shippingInfo["Global Shipping"]!)
        }
        if shippingInfo["Handling Time"] != nil {
            shippingTitles.append("Handling Time")
            let time = shippingInfo["Handling Time"]
            if time == "0" || time == "1" {
                shippingValues.append(time!+" day")
            } else {
                shippingValues.append(time!+" days")
            }
        }
        
        
        // Getting titles for Return Policy
        if returnPolicy["Policy"] != nil {
            returnTitles.append("Policy")
            returnValues.append(returnPolicy["Policy"]!)
        }
        if returnPolicy["Refund Mode"] != nil {
            returnTitles.append("Refund Mode")
            returnValues.append(returnPolicy["Refund Mode"]!)
        }
        if returnPolicy["Return Within"] != nil {
            returnTitles.append("Return Within")
            returnValues.append(returnPolicy["Return Within"]!)
        }
        if returnPolicy["Shipping Cost Paid By"] != nil {
            returnTitles.append("Shipping Cost Paid By")
            returnValues.append(returnPolicy["Shipping Cost Paid By"]!)
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
