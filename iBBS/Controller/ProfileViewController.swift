//
//  ProfileViewController.swift
//  iBBS
//
//  Created by zm on 11/19/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ProfileViewController: UITableViewController {

    var data: [AnyObject] = [AnyObject]()
    let oauth_token = KeychainWrapper.stringForKey("oauth_token")!
    var currentUser: User?
    var profileHeaderView: ProfileHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
//        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {

        loadCurrentUser()
        self.clearAllNotice()
    }
    
    private func loadCurrentUser() {
        
        if currentUser == nil {
            
            let userDal = UserDal()
            currentUser = userDal.getCurrentUser()
            
            if currentUser != nil {
                
                self.profileHeaderView?.setData(self.currentUser!)
                
            } else {
                currentUser?.face_url = data[0].valueForKey("face_url") as? String
                currentUser?.id = data[0].valueForKey("id") as! String
                currentUser?.level = data[0].valueForKey("level") as! String
                currentUser?.life = data[0].valueForKey("life") as! Int16
                currentUser?.post_count = data[0].valueForKey("post_count") as! Int32
                currentUser?.user_name = data[0].valueForKey("user_name") as! String
//                print(currentUser)
                self.profileHeaderView?.setData(self.currentUser!)
            }
        }
        
    }
    
    func setView() {
        
        self.profileHeaderView = ProfileHeaderView.viewFromNib()!
        self.profileHeaderView?.frame = CGRectMake(0, 0, self.view.frame.width, 280);
        self.tableView.tableHeaderView = self.profileHeaderView!
//        self.loadData()
    }
    
/*    func loadData() {
        
        let url = "http://bbs.byr.cn/open/user/getinfo.json?oauth_token=\(oauth_token)"
        Alamofire.request(NSURLRequest(URL: NSURL(string: url)!)).responseJSON{
            closureResponse in

            if closureResponse.result.isFailure {
                let ac = UIAlertController(title: "网络异常", message: "请检查网络设置", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
                
            } else {
                let json = closureResponse.result.value
                let result = JSON(json!)
                print(result)
                if result !=  nil {
                    let items = result.object as! [AnyObject]
                    print(items)
                    for item in items {
                        self.data.append(item)
                    }

                }
            }
        }
    }
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? MailController {
            
            switch segue.identifier! {
                case "inbox":
                vc.type = "inbox"
                case "outbox":
                vc.type = "outbox"
                case "reply":
                vc.type = "reply"
                case "at":
                vc.type = "at"
                default: break
            }
        }
//        } else {
//            let vc = segue.destinationViewController as! SetController
//        }
    }
}
