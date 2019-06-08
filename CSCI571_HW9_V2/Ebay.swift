//
//  Ebay.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/21/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Ebay {
    var location: String?
    var title: String?
    //var sellerInfo: [String:String] = [:]
    var price: String?
    var postalCode: String?
    var itemId: String?
    var viewItemURL: String?
    var condition: String?
    var shippingInfo: [String:String] = [:]
    var shippingPrice: String?
    var galleryURL: String?
    var itemImage: UIImage?
    var returnsAccepted: String?
    var returnsPolicy: String?
    var shipToLocations: [String] = Array()
    var handlingTime: String?
    var expeditedShipping: String?
    var oneDayShippingAvaliable: String?
    
    // Detail search
    var pictureURL: [String] = Array()
    var nameValueList: [String:String] = [:]
    var nameValueKeyArray: [String] = Array()
    // Seller Info
    var sellerInfo: [String:Any] = [:]
    var feedBackScore: Int?
    var popularity: Double?
    var feedbackRatingStart: String?
    var topRatedSeller: Bool?
    // Storefront
    var storeName: String?
    var storeURL: String?
    // Return Policy
    var returnPolicy: [String:String] = [:]
    var globalShipping: Bool?
    var subTitle: String?
    var WishList = false
}
