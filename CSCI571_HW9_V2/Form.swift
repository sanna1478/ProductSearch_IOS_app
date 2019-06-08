//
//  Form.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/19/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner

// Create a form class that contains all the user inputted data
class Form {
    var keyword: String?
    var category: String?
    var condition = [false,false,false]
    var shipping = [false,false]
    var dist: String?
    var customLocation = false
    var localZip: String?
    var alienZip: String?
    var finalZip: String?
    var customZip: [String] = Array()
    var categoryDictionary:[String:String] = [
        "All":"0",
        "Art":"550",
        "Baby":"2984",
        "Books":"267",
        "Clothing,Shoes & Accesories":"11450",
        "Computers/Tablets & Networking":"58058",
        "Health & Beauty":"26395",
        "Music":"11233",
        "Video Games & Consoles":"1249"
    ]
    var ebayItems: [Ebay] = Array()
    var ebaySimilarItem: [Similar] = Array()
    var finishedHttpRequest = false
    var detailedEbayItem = Ebay()
    var googleImageURLs: [String] = Array()
    
    func getSearchResult(_ table: UITableView) {
        SwiftSpinner.show("Searching..")
        let api_call = "https://testhw9.appspot.com"
        let parameters: Parameters = [
            "ebaySearch":"true",
            "keyword":self.keyword!,
            "postCode":self.finalZip!,
            "category":self.categoryDictionary[self.category!]!,
            "localPickup":self.shipping[0],
            "freeShipping":self.shipping[1],
            "distance":self.dist!,
            "new":self.condition[0],
            "used":self.condition[1],
            "unspecified":self.condition[2]
        ]
        
        let url = URL(string: api_call)
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters).responseJSON { response in
            if(response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                self.ebayItems.removeAll()
                // TODO: Check the number of items and wether success of fail
                self.parseEbaySearchResult(swiftyJsonVar["findItemsAdvancedResponse"][0])
                SwiftSpinner.hide()
                print("Search Request: \(String(describing: response.request))")
                self.finishedHttpRequest = true
                table.reloadData()
            }
        }
    }
    
    func getItemDetails(_ item: Ebay, completion: @escaping (Ebay) -> ()) {
        SwiftSpinner.show("Fetching Product Details")
        let api_call = "https://testhw9.appspot.com"
        let parameters: Parameters = [
            "ebayDetails":"true",
            "itemID":item.itemId!
        ]
        let url = URL(string: api_call)
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters).responseJSON { response in
            if(response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                self.parseDetailResult(swiftyJsonVar["Item"], item)
                SwiftSpinner.hide()
                print("Deiled Items Request: \(String(describing: response.request))")
            }
            completion(self.detailedEbayItem)
        }
        
    }
    
    func getGoogleImages(_ item: Ebay, completion: @escaping (Array<String>) -> ()) {
        SwiftSpinner.show("Fetching Google Images")
        let api_call = "https://testhw9.appspot.com"
        let parameters: Parameters = [
            "googleSearch":"true",
            "productTitle":item.title!
        ]
        let url = URL(string: api_call)
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters).responseJSON { response in
            if(response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                for index in 0..<swiftyJsonVar.count {
                    let imgLink = swiftyJsonVar[index]["link"]
                    self.googleImageURLs.append(imgLink.string!)
                }
                SwiftSpinner.hide()
                print("Google Images Request: \(String(describing: response.request))")
            }
            completion(self.googleImageURLs)
        }
    }
    
    func getSimilarItems(_ item: Ebay, _ collection: UICollectionView) {
        SwiftSpinner.show("Fetching Similar Items")
        let api_call = "https://testhw9.appspot.com"
        let parameters: Parameters = [
            "similarSearch":"true",
            "itemId":item.itemId!
        ]
        let url = URL(string: api_call)
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters).responseJSON {response in
            if(response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                //print(swiftyJsonVar)
                self.parseSimilarData(swiftyJsonVar["getSimilarItemsResponse"]["itemRecommendations"]["item"])
                SwiftSpinner.hide()
                print("Similar Items Request: \(String(describing: response.request))")
                collection.reloadData()
            }
        }
    }
    
    func parseSimilarData(_ json: JSON) {
        for index in 0..<json.count {
            let similarItem = Similar()
            let jsonItem = json[index]
            similarItem.timeLeft = jsonItem["timeLeft"].string
            similarItem.price = "$"+jsonItem["buyItNowPrice"]["__value__"].string!
            similarItem.itemURL = jsonItem["viewItemURL"].string
            similarItem.imgURL = jsonItem["imageURL"].string
            if jsonItem["shippingCost"]["__value__"].string == "0.00" {
                similarItem.shippingCost = "FREE SHIPPING"
            } else {
                similarItem.shippingCost = "$"+jsonItem["shippingCost"]["__value__"].string!
            }
            similarItem.title = jsonItem["title"].string
            self.ebaySimilarItem.append(similarItem)
        }
    }
    func getLocalZip() {
        let api_call = "http://ip-api.com/json/"
        let parameters: Parameters = [
            "fields":"zip",
        ]
        
        let url = URL(string: api_call)
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters).responseJSON { response in
            if(response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                self.localZip = swiftyJsonVar["zip"].string
            }
        }
    }
    
    func getCustomZip(_ zipcode: String, _ table: UITableView) {
        let api_call = "https://testhw9.appspot.com"
        let parameters = [
            "getlocalzipcode":"true",
            "postcode":zipcode,
        ]
        let url = URL(string: api_call)
        
        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { response in
            if(response.result.value != nil) {
                self.customZip.removeAll()
                let swiftyJsonVar = JSON(response.result.value!)
                for item in swiftyJsonVar["postalCodes"].arrayValue {
                    self.customZip.append(item["postalCode"].string!)
                }
                if self.customZip.count > 0 {
                    table.isHidden = false
                } else {
                    table.isHidden = true
                }
                print("Geoname Request: \(String(describing: response.request))")
                table.reloadData()
            }
        }
    }
    
    func validateDistance() -> Bool {
        if self.dist?.count == 0 {
            self.dist = "10"
        }
        let distanceRegEx = "^[0-9]{1,6}$"
        let distanceTest = NSPredicate(format:"SELF MATCHES %@",distanceRegEx)
         return distanceTest.evaluate(with: self.dist)
    }
    
    func validateKeyword() -> Bool {
        if self.keyword?.count == 0 {
            return false
        }
        return true
    }
    
    func validateZipCode() -> Bool {
        if self.customLocation == true {
            self.finalZip = self.alienZip
        } else {
            self.finalZip = self.localZip
        }
        let zipcodeRedEx = "^[0-9]{5,5}$"
        let zipcodeTest = NSPredicate(format: "SELF MATCHES %@", zipcodeRedEx)
        return zipcodeTest.evaluate(with: self.finalZip)
    }
    
    
    func parseDetailResult(_ json: JSON, _ item: Ebay) {
        if json["Subtitle"].exists() {
            item.subTitle = json["Subtitle"].string!
        }
        if json["Seller"].exists() {
            let subJson = json["Seller"]
            if subJson["PositiveFeedbackPercent"].exists() {
                item.popularity = subJson["PositiveFeedbackPercent"].double
                item.sellerInfo["Popularity"] = subJson["PositiveFeedbackPercent"].double
            }
            if subJson["FeedbackScore"].exists() {
                item.feedBackScore = subJson["FeedbackScore"].int
                item.sellerInfo["Feedback Score"] = subJson["FeedbackScore"].double
            }
            if subJson["FeedbackRatingStar"].exists() {
                item.feedbackRatingStart = subJson["FeedbackRatingStar"].string
                item.sellerInfo["Feedback Star"] = subJson["FeedbackRatingStar"].string
            }
            if subJson["TopRatedSeller"].exists() {
                item.topRatedSeller = subJson["TopRatedSeller"].bool
            }
        }
        if json["Storefront"].exists() {
            let subJson = json["Storefront"]
            if subJson["StoreName"].exists() {
                item.storeName = subJson["StoreName"].string
                item.sellerInfo["Store Name"] = subJson["StoreName"].string
            }
            if subJson["StoreURL"].exists() {
                item.storeURL = subJson["StoreURL"].string
                item.sellerInfo["StoreURL"] = subJson["StoreURL"].string
            }
        }
        if json["PictureURL"].exists() {
            item.pictureURL.removeAll()
            for index in 0..<json["PictureURL"].count {
                item.pictureURL.append(json["PictureURL"][index].string!)
            }
        }
        if json["ItemSpecifics"]["NameValueList"].exists() {
            item.nameValueKeyArray.removeAll()
            let list = json["ItemSpecifics"]["NameValueList"]
            for index in 0..<list.count {
                let key = list[index]["Name"].string!
                let value = list[index]["Value"][0].string!
                item.nameValueList[key] = value
                item.nameValueKeyArray.append(key)
            }
        }
        if json["GlobalShipping"].exists() {
            item.globalShipping = json["GlobalShipping"].bool
            if item.globalShipping == true {
                item.shippingInfo["GlobalShipping"] = "Yes"
            } else {
                item.shippingInfo["GlobalShipping"] = "No"
            }
            
        }
        if json["ReturnPolicy"].exists() {
            let policy = json["ReturnPolicy"]
            if policy["ShippingCostPaidBy"].exists() {
                item.returnPolicy["Shipping Cost Paid By"] = policy["ShippingCostPaidBy"].string
            }
            if policy["ReturnsWithin"].exists() {
                item.returnPolicy["Return Within"] = policy["ReturnsWithin"].string
            }
            if policy["ReturnsAccepted"].exists() {
                item.returnPolicy["Policy"] = policy["ReturnsAccepted"].string
            }
            if policy["Refund"].exists() {
                item.returnPolicy["Refund Mode"] = policy["Refund"].string
            }
        }
        self.detailedEbayItem = item
    }
    
    func parseEbaySearchResult(_ json: JSON) {
        let searchResult = json["searchResult"][0]
        let items = searchResult["item"]
        
        //print(items[0])
        for item in items.arrayValue {
            let ebay = Ebay()
            
            // LOCATION:
            if item["location"].exists() {
                ebay.location = item["location"][0].string!
            }
            
            // TITLE:
            if item["title"].exists() {
                ebay.title = item["title"][0].string!
            } else {
                ebay.title = "N/A"
            }
            
            // SELLERINFO: TODO ONLY NECCESARY STUFF
            /*if item["sellerInfo"].exists() {
                for (key,subItem):(String,JSON) in item["sellerInfo"][0] {
                    ebay.sellerInfo[key] = subItem[0].string!
                }
            }*/
            
            // SELLINGSTATUS: TODO ONLY NECCESARY STUFF
            if item["sellingStatus"].exists() {
                if item["sellingStatus"][0]["currentPrice"].exists() {
                    ebay.price = item["sellingStatus"][0]["currentPrice"][0]["__value__"].string!
                } else {
                    ebay.price = "N/A"
                }
            }
            
            // POSTALCODE:
            if item["postalCode"].exists() {
                ebay.postalCode = item["postalCode"][0].string!
            } else {
                ebay.postalCode = "N/A"
            }
            
            // ITEMID:
            if item["itemId"].exists() {
                ebay.itemId = item["itemId"][0].string!
            } else {
                ebay.itemId = "N/A"
            }
            
            // VIEWITEMURL:
            if item["viewItemURL"].exists() {
                ebay.viewItemURL = item["viewItemURL"][0].string!
            }
            
            // CONDITION:
            if item["condition"].exists() {
                if item["condition"][0]["conditionId"].exists() {
                    ebay.condition = item["condition"][0]["conditionId"][0].string!
                    switch ebay.condition {
                    case "1000":
                        ebay.condition = "NEW"
                    case "2000":
                        ebay.condition = "REFURBISHED"
                    case "2500":
                        ebay.condition = "REFURBISHED"
                    case "3000":
                        ebay.condition = "USED"
                    case "4000":
                        ebay.condition = "USED"
                    case "5000":
                        ebay.condition = "USED"
                    case "6000":
                        ebay.condition = "USED"
                    default:
                        ebay.condition = "NA"
                    }
                }
            }
            
            // SHIPPING: TODO ONLY NECESSARY STUFF
            if item["shippingInfo"].exists() {
                for (key,subItem):(String,JSON) in item["shippingInfo"][0] {
                    if key == "shippingServiceCost" {
                        if subItem[0]["__value__"].string == "0.0" {
                            ebay.shippingPrice = "FREE SHIPPING"
                            ebay.shippingInfo["Shipping Cost"] = "FREE"
                        } else {
                            if subItem[0]["__value__"].string != nil {
                                ebay.shippingPrice = subItem[0]["__value__"].string!
                                ebay.shippingInfo["Shipping Cost"] = ebay.shippingPrice
                            }
                        }
                    }
                    
                    if key == "shipToLocations" {
                        for index in 0..<subItem.count {
                            ebay.shipToLocations.append(subItem[index].string!)
                        }
                    }
                    
                    if key == "handlingTime" {
                        ebay.handlingTime = subItem[0].string!
                        ebay.shippingInfo["Handling Time"] = ebay.handlingTime
                    }
                    
                    if key == "expeditedShipping" {
                        ebay.expeditedShipping = subItem[0].string!
                    }
                    if key == "oneDayShippingAvaliable" {
                        ebay.oneDayShippingAvaliable = subItem[0].string!
                    }
                    
                }
                if ebay.shippingPrice == nil {
                    ebay.shippingPrice = "N/A"
                }
            }
            
            // GALLERYURL:
            if item["galleryURL"].exists() {
                ebay.galleryURL = item["galleryURL"][0].string!
                /*let url = URL(string: ebay.galleryURL!)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    ebay.itemImage = image
                }*/
            }
            
            // RETURNPOLICY:
            if item["returnsPolicy"].exists() {
                ebay.returnsPolicy = item["returnsPolicy"][0].string!
            }
            
            // RETURNACCEPTED:
            if item["returnsAccepted"].exists() {
                ebay.returnsAccepted = item["returnsAccepted"][0].string!
            }
            
            self.ebayItems.append(ebay)
        }
    }
}
