//
//  BoardController.swift
//  iBBS
//
//  Created by zm on 12/28/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BoardController: UITableViewController {

    var data: [AnyObject] = [AnyObject]()
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    var board_name = ""
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tableView.addFooterWithCallback {
            if (self.data.count > 0) {
                ++self.page
                self.loadData()
            }
        }
//        let leftBarButton = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "backToPrevious")
//        self.navigationItem.leftBarButtonItem = leftBarButton
//        self.tableView.addHeaderWithCallback {
//            self.loadData()
//        }
//        self.tableView.headerBeginRefreshing()
    }
    
//    func backToPrevious() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func loadData() {

        let url = "http://bbs.byr.cn/open/board/\(board_name).json?oauth_token=\(oauth_token)&page=\(page)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in

            self.tableView.footerEndRefreshing()
            if closureResponse.result.isFailure {
                
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                
                let json = closureResponse.result.value
                let result = JSON(json!)
                if result !=  nil {
                    let items = result["article"].object as! [AnyObject]
                    
//                    self.data.removeAll(keepCapacity: false)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath)
        let item = self.data[indexPath.row]
        cell.textLabel?.text = item.valueForKey("title") as? String
        cell.detailTextLabel?.text = item.valueForKey("user")?.valueForKey("id") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "boardToArticle" {
            let vc = segue.destinationViewController as! ArticleDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let article = self.data[indexPath!.row]
            vc.article = article

        } else if segue.identifier == "postNew" {
            let vc = segue.destinationViewController as! AddArticleController
            vc.name = self.board_name
        }
    }

}
