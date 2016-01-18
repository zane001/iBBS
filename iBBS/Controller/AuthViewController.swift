//
//  AuthViewController.swift
//  iBBS
//
//  Created by zm on 11/21/15.
//  Copyright © 2015 zm. All rights reserved.
//

import OAuthSwift
import UIKit

class AuthViewController: UIViewController {
    
    final var oauth_token: String!
    
    func doOAuthByr() {
        let oauthswift = OAuth2Swift (
            consumerKey: "64901bbd8dac3e5d85a52dacdfda6595",
            consumerSecret: "e274c4b24c452562aedabcc997dfa2d9",
            authorizeUrl:    "http://bbs.byr.cn/oauth2/authorize",
            accessTokenUrl: "http://bbs.byr.cn/oauth2/token",
            responseType:   "token"
            
        )
        oauthswift.authorize_url_handler = get_url_handler()
        
        let state: String = generateStateWithLength(20) as String
        //        oauthswift.authorizeWithCallbackURL(NSURL(string: "iBBS://oauth-callback/byr")!, scope: "", state: state,
        oauthswift.authorizeWithCallbackURL(NSURL(string: "http://bbs.byr.cn/oauth2/callback")!, scope: "", state: state,params: ["bundle_id": "com.zm.iBBS"],
            success: {
                credential, response, parameters in

                //            self.testByr(oauthswift)
                
                self.oauth_token = credential.oauth_token
                KeychainWrapper.setString(self.oauth_token, forKey: "oauth_token")
//                self.segueToHome()
                
            },
            failure:  { error in
                print(error)
            }
        )
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToHome" {

//            if let destinationVC = segue.destinationViewController as? TopTenController {
//                if self.oauth_token != nil {
//                    destinationVC.oauth_token = self.oauth_token
//                    print(destinationVC.oauth_token)
//                }
//            }
//            if self.oauth_token != nil {
//                
//                KeychainWrapper.setString(oauth_token, forKey: "oauth_token")
//            }
            
        }
    }
    
    
    func segueToHome() {
        performSegueWithIdentifier("segueToHome", sender: self)
    }
    
    func showAlertView(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: create an optionnal internal web view to handle connection
    func createWebViewController() -> WebViewController {
        let controller = WebViewController()
        
        return controller
    }
    
    func get_url_handler() -> OAuthSwiftURLHandlerType {
        // Create a WebViewController with default behaviour from OAuthWebViewController
        let url_handler = createWebViewController()
        
        return url_handler
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        loadAuthPage()
        //        get_url_handler()
        presentingViewController!.dismissViewControllerAnimated(true) { _ in

            self.doOAuthByr()
        }

    }
    
}
