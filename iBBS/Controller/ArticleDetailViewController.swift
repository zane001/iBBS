//
//  ArticleDetailViewController.swift
//  iBBS
//
//  Created by zm on 12/19/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ArticleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var article: AnyObject?
    var articleDetail: JSON = nil
    var data: [AnyObject] = [AnyObject]()
    var page = 1
    var loading = false
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    var page_all_count = 0
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputReply: UITextView!
    @IBOutlet weak var inputWrapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        self.setViews()
        self.inputReply.layer.borderWidth = 1
        self.inputReply.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.9).CGColor
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        getDefaultData()
        
        self.tableView.addFooterWithCallback {
            if (self.data.count > 0) {
                ++self.page
                if (self.page <= self.page_all_count) {
                    self.loadData()
                } else {
                    self.tableView.footerEndRefreshing()
                    self.notice("已到最后一页", type: .info, autoClear: true)
                }
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endKeyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        var frame = self.view.frame
        frame.origin.y = -endKeyboardRect.height
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            for constraint in self.inputWrapView.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.Height {
                    let inputWrapConstraint = constraint as NSLayoutConstraint
                    inputWrapConstraint.constant = 80
                    break;
                }
            }
            
            self.view.frame = frame
            
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var frame = self.view.frame
        frame.origin.y = 0 // keyboardHeight
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

            self.view.frame = frame
            for constraint in self.inputWrapView.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.Height {
                    let inputWrapContraint = constraint as NSLayoutConstraint
                    inputWrapContraint.constant = 50
                    break;
                }
            }
            
            }, completion: nil)
        
    }
    

    func loadData() {
        
        if (self.loading) { return }
        
//        let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
        let id = article!.valueForKey("id") as! Int
        let board_name = article!.valueForKey("board_name") as! String

//        print("page: \(page)")
        let url = "http://bbs.byr.cn/open/threads/\(board_name)/\(id).json?oauth_token=\(oauth_token)&page=\(page)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in
            self.loading = false
            self.tableView.footerEndRefreshing()
            
            if closureResponse.result.isFailure {
                
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                
                let json = closureResponse.result.value
                let result = JSON(json!)
                
                let pageJSON = result["pagination"]["page_all_count"]
                self.page_all_count = pageJSON.intValue
                
                if result !=  nil {
                    let items = result["article"].object as! [AnyObject]
                
                    for item in items {
                        self.data.append(item)
                    }
                
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.inputWrapView.hidden = false
                }
            }
            
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleCell
        let item: AnyObject = self.data[indexPath.row]
        
        if let face_url = item.valueForKey("user")?.valueForKey("face_url") as? String {
            cell.face.kf_setImageWithURL(NSURL(string: face_url)!, placeholderImage: nil)
        }
        cell.face.layer.cornerRadius = 5
        cell.face.layer.masksToBounds = true
        cell.user.text = item.valueForKey("user")?.valueForKey("id") as? String
        let floor = item.valueForKey("position") as! Int
        if floor == 0 {
            cell.floor.text = "楼主"
        } else {
            cell.floor.text = "\(floor) 楼"
        }
        
/*        let urlFiles = item.valueForKey("attachment")?.valueForKey("file") as? [AnyObject]
        var uploadViews: [UIImageView]!
        if urlFiles != nil {
            for url in urlFiles! {
                //                print(url.valueForKey("thumbnail_small")!)
                var imageUrl = url.valueForKey("thumbnail_small")!
                imageUrl = "\(imageUrl)?oauth_token=\(oauth_token)"
                let nsData = NSData(contentsOfURL: NSURL(string: imageUrl as! String)!)!
                let image = UIImage(data: nsData)!
                let uploadView = makeImageView(CGRectMake(0, 0, 100, 100), image: image)
                uploadViews.append(uploadView)
            }
        }
*/        
//        使用正则表达式将帖子内容中的[upload=xxx][/upload]替换为空白
        let originalContent = item.valueForKey("content") as? String
//        cell.content.text = originalContent?.stringByReplacingOccurrencesOfString("[upload=", withString: "")
        let pattern: String = "\\[upload=[0-9]{1,2}\\]\\[/upload\\]"
      
        do {
            let exp = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSMakeRange(0, originalContent!.characters.count)
            let newStr = NSMutableString(string: originalContent!)
            exp.replaceMatchesInString(newStr, options: [], range: range, withTemplate: "")
//            let result = exp.matchesInString(newStr as String, options: .ReportCompletion, range: range)
//            for (var i=0; i<result.count; i++) {
//                cell.content.addSubview(uploadViews[i])
//            }
            cell.content.text = newStr as String
        } catch {
            
        }

        
        let createTime = item.valueForKey("post_time") as! Double
        let createDate = NSDate(timeIntervalSince1970: createTime)
        
        self.title = item.valueForKey("title") as? String
        cell.post_time.text = Utility.formatDate(createDate)
        cell.selectionStyle = .None
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleCell
        cell.containerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.9)
    }
    
    
    private func configureCell(cell: ArticleCell, indexPath: NSIndexPath, isForOffscreenUse: Bool) {
        let item: AnyObject = self.data[indexPath.row]
        cell.floor.text = item.valueForKey("position") as? String
        cell.selectionStyle = .None
    }
    
    var prototypeCell: ArticleCell?
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if prototypeCell == nil {
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("ArticleCell") as? ArticleCell
        }
        self.configureCell(prototypeCell!, indexPath: indexPath, isForOffscreenUse: false)
        self.prototypeCell?.setNeedsUpdateConstraints()
        self.prototypeCell?.updateConstraintsIfNeeded()
        self.prototypeCell?.setNeedsLayout()
        self.prototypeCell?.layoutIfNeeded()
        let size = self.prototypeCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    func setViews() {
        
//        这是纯代码写的tableView，当然可以直接在storyborad里ctrl + drag
//        tableView = UITableView(frame: self.view.bounds, style: .Plain)
//        self.view.addSubview(tableView)
//        tableView.registerClass(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
//        tableView.delegate = self
//        tableView.dataSource = self
        self.inputReply.resignFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        self.startLoading()
        self.inputWrapView.hidden = true

        self.loadData()
    }
    
    @IBAction func replyClick(sender: AnyObject) {
        let content = inputReply.text
        inputReply.text = ""
        if content != nil {
            let id = article!.valueForKey("id") as! Int
            let board_name = article!.valueForKey("board_name") as! String
            let title = article!.valueForKey("title") as! String
            let params:[String: AnyObject] = ["title": title, "reid": id, "content": content]
            let url = "http://bbs.byr.cn/open/article/\(board_name)/post.json?oauth_token=\(oauth_token)"

            Alamofire.request(.POST, url, parameters: params).responseJSON {
                closureResponse in
                if closureResponse.result.isFailure {
                    self.notice("网络异常", type: NoticeType.error, autoClear: true)
                    return
                } else {
                    self.notice("回复成功", type: NoticeType.success, autoClear: true)
                }
               
            }
        }
//        self.loadData()
    }

    
    func startLoading() {
        self.pleaseWait()
    }
    
    func stopLoading() {
        self.clearAllNotice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearAllNotice()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.stopLoading()
    }
}
