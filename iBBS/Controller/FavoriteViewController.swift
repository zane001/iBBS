//
//  FavoriteViewController.swift
//  iBBS
//
//  Created by zm on 12/23/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavoriteViewController: UITableViewController {
    var data: [AnyObject] = [AnyObject]()
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        findBoard()
    }
    
    func loadData() {
        let url = "http://bbs.byr.cn/open/favorite/0.json?oauth_token=\(oauth_token)"
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
                    let items = result["board"].object as! [AnyObject]
                    
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
    
    //遍历分区下的子分区，以及版面列表
/*    func findBoard() {
        var id = 10
        var id1 = 11
        var pid1 = 0
        var pid2 = 0
        for i in 0 ..< 10 {
           
            let url = "http://bbs.byr.cn/open/section/\(i).json?oauth_token=\(oauth_token)"
        
            Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in
            
            if closureResponse.result.isFailure {
                
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                
                let json = closureResponse.result.value
                let result = JSON(json!)
                if result["sub_section"].count > 0 {
                    let items = result["sub_section"].object as! [AnyObject]
                    let boards = result["board"].object as! [AnyObject]
                    pid1 = i + 1
                    
                    for item in items {
                        print("<dict>")
                        print("<key>id</key>")
                        print("<string>\(++id)</string>")
                        print("<key>pid</key>")
                        print("<string>\(pid1)</string>")
                        print("<key>name</key>")
                        print("<string>\(item)</string>")
                        print("<key>description</key>")
                        print("<string>子分区</string>")
                        print("</dict>")
                   
                    
//                    for item in items {
                        let url = "http://bbs.byr.cn/open/section/\(item).json?oauth_token=\(self.oauth_token)"
                        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
                            closureResponse in
                            
                            if closureResponse.result.isFailure {
                                
                                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(ac, animated: true, completion: nil)
                                
                            } else {
                                
                                let json = closureResponse.result.value
                                let result = JSON(json!)
                                let items = result["board"].object as! [AnyObject]
                                pid2 = id1
                                for item in items {
                                    print("<dict>")
                                    print("<key>id</key>")
                                    print("<string>\(++id)</string>")
                                    print("<key>pid</key>")
                                    print("<string>\(pid2)</string>")
                                    print("<key>name</key>")
                                    print("<string>\(item["name"])</string>")
                                    print("<key>description</key>")
                                    print("<string>\(item["description"])</string>")
                                    print("</dict>")
                                }
                                ++id1
                            }
                            
                        }
//                    }
                    }
                    
                    for item in boards {
                        print("<dict>")
                        print("<key>id</key>")
                        print("<string>\(++id)</string>")
                        print("<key>pid</key>")
                        print("<string>\(pid1)</string>")
                        print("<key>name</key>")
                        print("<string>\(item["name"])</string>")
                        print("<key>description</key>")
                        print("<string>\(item["description"])</string>")
                        print("</dict>")
                    }
                    
                } else {
                    let boards = result["board"].object as! [AnyObject]
                    pid1 = i + 1
                    for item in boards {
                        print("<dict>")
                        print("<key>id</key>")
                        print("<string>\(++id)</string>")
                        print("<key>pid</key>")
                        print("<string>\(pid1)</string>")
                        print("<key>name</key>")
                        print("<string>\(item["name"])</string>")
                        print("<key>description</key>")
                        print("<string>\(item["description"])</string>")
                        print("</dict>")
                    }
                }
            }
         }
        }
    }
*/
    
    // MARK: Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath)
        let item = self.data[indexPath.row]
        cell.textLabel?.text = item.valueForKey("name") as? String
        cell.detailTextLabel?.text = item.valueForKey("description") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "favoriteToBoard" {
            let vc = segue.destinationViewController as! BoardController
            let indexPath = self.tableView.indexPathForSelectedRow
            let board_name = self.data[indexPath!.row].valueForKey("name") as! String

            vc.board_name = board_name
            
        }
    }
}
