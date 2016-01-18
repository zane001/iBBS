//
//  MailController.swift
//  iBBS
//
//  Created by zm on 1/1/16.
//  Copyright © 2016 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MailController: UITableViewController {

    var type: String!
    var data: [AnyObject] = [AnyObject]()
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        var url: String!
        if type == "inbox" || type == "outbox" {
            url = "http://bbs.byr.cn/open/mail/\(type).json?oauth_token=\(oauth_token)"
        } else {
            url = "http://bbs.byr.cn/open/refer/\(type).json?oauth_token=\(oauth_token)"
        }
        
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in
            
            self.tableView.headerEndRefreshing()
            if closureResponse.result.isFailure {
                
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                
                let json = closureResponse.result.value
                let result = JSON(json!)
                if (result["description"] == "发件箱" || result["description"] == "收件箱") {

                    let items = result["mail"].object as! [AnyObject]
                    
                    for item in items {
                        self.data.append(item)
                    }
                } else {
                    let items = result["article"].object as! [AnyObject]
                    
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
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mail", forIndexPath: indexPath)
        let item = self.data[indexPath.row]
        cell.textLabel?.text = item.valueForKey("title") as? String
        cell.detailTextLabel?.text = item.valueForKey("user")?.valueForKey("id") as? String
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
