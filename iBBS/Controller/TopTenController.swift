//
//  TopTenController.swift
//  iBBS
//
//  Created by zm on 6/1/16.
//  Copyright © 2016 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class TopTenController: UITableViewController {
    
    var data: [AnyObject] = [AnyObject]()
    var loading: Bool = false
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "十大热门话题"
        
        getDefaultData()
        self.tableView.addHeaderWithCallback {
            self.loadData(0, isPullRefresh: true)
        }
        self.loadData()
        
//       self.tableView.addFooterWithCallback {
//            if (self.data.count > 0) {
//                let maxId = self.data.last!.valueForKey("id") as! Int32
//                self.loadData(maxId, isPullRefresh: false)
//            }
//        }

        self.tableView.headerBeginRefreshing()
        
    }
    
    func getDefaultData() {
        let articleDal = ArticleDal()
        let result = articleDal.getArticleList()
        if result != nil {
            self.data = result!
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView Data Source
    
    func loadData(maxId: Int32, isPullRefresh: Bool) {
        
        if (self.loading) {
            return
        }
        
        self.loading = true
        
//        let url: String = "http://bbs.byr.cn/open/widget/topten.json?oauth_token=27908c21fc753925f85eb75ae8f4618c"
//        oauth_token = KeychainWrapper.stringForKey("oauth_token")
//        print("TopTen: \(oauth_token)")
        if oauth_token == nil {
//            重新授权
            let vc = AuthViewController()
            self.presentViewController(vc, animated: true, completion: nil)
        }
        let url = "http://bbs.byr.cn/open/widget/topten.json?oauth_token=\(oauth_token!)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON {
            closureResponse in
            self.loading = false
            if (isPullRefresh) {
                self.tableView.headerEndRefreshing()
            } else {
                self.tableView.footerEndRefreshing()
            }
            
            if (closureResponse.result.isFailure) {
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                return
            }
            
            let json = closureResponse.result.value
            var result = JSON(json!)
//            print(result)
            if (result["msg"] != nil && result["msg"].object.containsString("过期")) {
                let vc = AuthViewController()
                self.presentViewController(vc, animated: true, completion: nil)

            } else {
                
                let items = result["article"].object as! [AnyObject]

                if (isPullRefresh) {
                    let articleDal = ArticleDal()
                    articleDal.deleteAll()
                    articleDal.addArticleList(items)
                    self.data.removeAll(keepCapacity: false)
                }
                
                for item in items {
                    self.data.append(item)
                }
            }
//            let user = result["article"]["user"].object as! [AnyObject]
//            for i in user {
//                self.user.append(i)
//            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            
            }
        }
    }
    
//    获取用户的信息
    func loadData() {
        
        let url = "http://bbs.byr.cn/open/user/getinfo.json?oauth_token=\(oauth_token!)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in
            
            if closureResponse.result.isFailure {
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                let json = closureResponse.result.value
                let result = JSON(json!)
                if (result["msg"] != nil && result["msg"].object.containsString("过期")) {
                    let vc = AuthViewController()
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    
                    let userDal = UserDal()
                    userDal.addUser(result, save: true)
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopTenCell", forIndexPath: indexPath) as! TopTenCell
        let item: AnyObject = self.data[indexPath.row]

        //        cell.face.kf_setImageWithURL(NSURL(string: item.valueForKey("face_url") as! String)!, placeholderImage: nil)
        if let face_url = item.valueForKey("user")?.valueForKey("face_url") as? String {
            cell.face.kf_setImageWithURL(NSURL(string: face_url)!, placeholderImage: nil)
        }
        cell.face.layer.cornerRadius = 5
        cell.face.layer.masksToBounds = true
        cell.user.text = item.valueForKey("user")?.valueForKey("id") as? String
        let reply_count = item.valueForKey("reply_count") as! Int
        cell.reply_count.text = "\(reply_count)"
        cell.title.text = item.valueForKey("title") as? String
        cell.board.text = item.valueForKey("board_name") as? String
        let createTime = item.valueForKey("post_time") as! Double
        let createDate = NSDate(timeIntervalSince1970: createTime)
        cell.post_time.text = Utility.formatDate(createDate)
        cell.selectionStyle = .None
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopTenCell", forIndexPath: indexPath) as! TopTenCell
        cell.containerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.9)
    }
    
    var prototypeCell: TopTenCell?
    
    private func configureCell(cell: TopTenCell, indexPath: NSIndexPath, isForOffscreenUse: Bool) {
        let item: AnyObject = self.data[indexPath.row]
        cell.title.text = item.valueForKey("title") as? String
        cell.board.text = item.valueForKey("board_name") as? String
        cell.selectionStyle = .None
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if prototypeCell == nil {
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("TopTenCell") as? TopTenCell
        }
        self.configureCell(prototypeCell!, indexPath: indexPath, isForOffscreenUse: false)
        self.prototypeCell?.setNeedsUpdateConstraints()
        self.prototypeCell?.updateConstraintsIfNeeded()
        self.prototypeCell?.setNeedsLayout()
        self.prototypeCell?.layoutIfNeeded()
        let size = self.prototypeCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
        
    }

    
//    @IBAction func addArticle(sender: AnyObject) {
//        if KeychainWrapper.stringForKey("oauth_token") == nil {
//            
//        }
//        
//    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toArticleDetail" {
            let vc = segue.destinationViewController as! ArticleDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let article = self.data[indexPath!.row]
            vc.article = article

        }
    }
}
