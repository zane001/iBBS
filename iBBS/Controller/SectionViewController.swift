//
//  SectionViewController.swift
//  iBBS
//
//  Created by zm on 12/23/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SectionViewController: UITableViewController {
    
    var data: [AnyObject] = [AnyObject]()
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let url = "http://bbs.byr.cn/open/section.json?oauth_token=\(oauth_token)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in
            
            if closureResponse.result.isFailure {
                
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                
                let json = closureResponse.result.value
                let result = JSON(json!)
                if result !=  nil {
                    let items = result["section"].object as! [AnyObject]
                    
                    for item in items {
                        self.data.append(item)
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    // MARK: Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath)
        let item = self.data[indexPath.row]
        cell.textLabel?.text = item.valueForKey("name") as? String
        cell.detailTextLabel?.text = item.valueForKey("description") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath)
        
    }
}
