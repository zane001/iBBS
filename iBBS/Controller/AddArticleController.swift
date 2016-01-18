//
//  AddArticleController.swift
//  iBBS
//
//  Created by zm on 1/1/16.
//  Copyright © 2016 zm. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddArticleController: UIViewController {

    @IBOutlet weak var newTitle: UITextField!
    
    @IBOutlet weak var content: UITextView!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func post(sender: AnyObject) {
        let title = self.newTitle.text
        let content = self.content.text
        
        if title!.isEmpty {
            self.notice("标题不能为空!", type: NoticeType.info, autoClear: true)
            return
        }
        
        if content.isEmpty {
            self.notice("内容不能为空!", type: NoticeType.info, autoClear: true)
            return
            
        }
        
        if title != nil {
            
            let btn = sender as! UIBarButtonItem
            btn.enabled = false
            
            let params: [String: AnyObject] = ["title": title!, "content": content!]
            let url = "http://bbs.byr.cn/open/article/\(name!)/post.json?oauth_token=\(KeychainWrapper.stringForKey("oauth_token")!)"
            Alamofire.request(.POST, url, parameters: params).responseJSON{
                closureResponse in

                btn.enabled = true
                if closureResponse.result.isFailure {
                    
                    self.notice("网络异常", type: NoticeType.error, autoClear: true)
                    return
                }
                
                let json = closureResponse.result.value
                let result = JSON(json!)

                if result != nil {
                    self.notice("发表成功", type: NoticeType.success, autoClear: true)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.notice("网络异常", type: NoticeType.error, autoClear: true)
                }
            }
        }

    }
    
    private func setView() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: newTitle.frame.size.height - width, width: newTitle.frame.size.width, height: width)
        
        border.borderWidth = width
        newTitle.layer.addSublayer(border)
        newTitle.layer.masksToBounds = true
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endKeyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            for constraint in self.view.constraints {
                
                let cons = constraint as NSLayoutConstraint
                
                if let _ = cons.secondItem as? UITextView {
                    
                    if cons.secondAttribute == NSLayoutAttribute.Bottom {
                        
                        cons.constant = 10 + endKeyboardRect.height
                        break;
                    }
                }
            }
            
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                
                for constraint in self.view.constraints {
                    
                    let cons = constraint as NSLayoutConstraint
                    
                    if let _ = cons.secondItem as? UITextView {
                        
                        if cons.secondAttribute == NSLayoutAttribute.Bottom {
                            
                            cons.constant = 10
                            break;
                        }
                    }
                }
            }, completion: nil)
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
