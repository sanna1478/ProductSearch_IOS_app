//
//  IconViewController.swift
//  CSCI571_HW9_V2
//
//  Created by Shreyash Annapureddy on 4/23/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class IconViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ItemPriceTitle: UILabel!
    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var DetailsTable: UITableView!
    
    var form = Form()
    var wishList: [String:Ebay] = [:]
    var ebayItem = Ebay()
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    var detailItem = Ebay()
    
    let cellIdentifier = "ReuseCell"
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        DetailsTable.dataSource = self
        DetailsTable.delegate = self
        
        
        let tabViewCtrl = tabBarController as! TabBarViewController
        self.form = tabViewCtrl.form
        self.wishList = tabViewCtrl.wishList
        self.ebayItem = tabViewCtrl.ebayItem
        
        form.getItemDetails(ebayItem) { (result) -> () in
            let item = self.form.detailedEbayItem
            self.detailItem = self.form.detailedEbayItem
            //print("Seller Info: \(self.detailItem.sellerInfo)")
            //print("Shipping Info: \(self.detailItem.shippingInfo)")
            //print("Return Policy: \(self.detailItem.returnPolicy)")
            let numImages = item.pictureURL.count
            self.pageControl.numberOfPages = numImages
            for index in 0..<numImages {
                self.frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                self.frame.size = self.scrollView.frame.size
                
                let imgView = UIImageView(frame: self.frame)
                let url = URL(string: item.pictureURL[index])
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    imgView.image = image
                    self.scrollView.addSubview(imgView)
                }
            }
            self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width * CGFloat(numImages)), height: self.scrollView.frame.size.height)
            self.scrollView.delegate = self
            self.scrollView.isPagingEnabled = true
            self.scrollView.showsHorizontalScrollIndicator = false
            
            self.ItemTitleLabel.text = item.title
            if item.price != nil {
                self.ItemPriceTitle.text = "$"+item.price!
            } else {
                self.ItemTitleLabel.text = item.price
            }
            self.DetailsTable.reloadData()
            let tabViewCtrl = self.tabBarController as! TabBarViewController
            tabViewCtrl.ebayItem = self.form.detailedEbayItem
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //let tabViewCtrl = tabBarController as! TabBarViewController
        //tabViewCtrl.ebayItem = self.form.detailedEbayItem
        //print(self.form.detailedEbayItem.sellerInfo)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var pageNum = scrollView.contentOffset.x / scrollView.frame.size.width
        //print("pagenum before rounding: \(pageNum)")
        pageNum = pageNum.rounded()
        //print("pagenum after rounding: \(pageNum)")
        pageControl.currentPage = Int(pageNum)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem.nameValueList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IconTableViewCell
        
        let key = self.detailItem.nameValueKeyArray[indexPath.row]
        cell?.TitleName.text = key
        cell?.TitleValue.text = self.detailItem.nameValueList[key]
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
