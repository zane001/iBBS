//
//  WebViewController.swift
//  iBBS
//
//  Created by zm on 11/29/15.
//  Copyright © 2015 zm. All rights reserved.
//
//  授权登陆页面

import OAuthSwift
import UIKit
typealias WebView = UIWebView // WKWebView


class WebViewController: OAuthWebViewController {
    
    var targetURL: NSURL = NSURL()
    let webView: WebView = WebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        self.webView.frame = UIScreen.mainScreen().bounds
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
        
    }
    
    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
    }
    
    
}

// MARK: delegate

extension WebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.URL where (url.scheme == "iBBS") {
            self.dismissWebViewController()
        } else if let url = request.URL where (url.absoluteString.containsString("access_token")) {
//            self.dismissWebViewController()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("home") as! HomeTabBarController
            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            presentViewController(vc, animated: true, completion: nil)
            
            OAuthSwift.handleOpenURL(url)

//            func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//                if segue.identifier == segue1 {
//                    if let dvc = segue.destinationViewController as? HomeTabBarController {
//                        performSegueWithIdentifier(segue1, sender: self)
//                        presentViewController(dvc, animated: true, completion: nil)
//                    }
//                }
//            }

        }
        return true
    }
}

