//
//  GuidanceViewController.swift
//  iBBS
//
//  Created by zm on 12/16/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit

class GuidanceViewController: UIViewController {
    var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    var numOfPages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        
        scrollView = UIScrollView()
        scrollView.frame = frame
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(frame.size.width * CGFloat(numOfPages), frame.size.height)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        for i in 0 ..< numOfPages {
            let image = UIImage(named: "Guidance\(i+1)")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(frame.size.width * CGFloat(i), 20, frame.size.width, frame.size.height - 20)
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentOffset = CGPointZero
        self.view.addSubview(scrollView)
        startButton.alpha = 0.0
        self.view.bringSubviewToFront(pageControl)
        self.view.bringSubviewToFront(startButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func start(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("oauth") as! AuthViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(vc, animated: true, completion: nil)

//        self.performSegueWithIdentifier("segueToAuth", sender: self)
    }
 
}

extension GuidanceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)

        // 因为currentPage是从0开始，所以numOfPages减1
        
        if pageControl.currentPage == numOfPages - 1 {
            
            UIView.animateWithDuration(0.5) {
                self.startButton.alpha = 1.0
            }
            
        } else {
            
            UIView.animateWithDuration(0.5) {
                self.startButton.alpha = 0.0
            }
        }
    }
}
