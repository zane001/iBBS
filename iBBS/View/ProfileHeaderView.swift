//
//  ProfileHeaderView.swift
//  iBBS
//
//  Created by zm on 12/23/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var life: UILabel!
    @IBOutlet weak var post_count: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var user_name: UILabel!

    var initialFrame: CGRect!
    var initialHeight: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        face.layer.cornerRadius = 50
        face.layer.borderWidth = 1
        face.layer.borderColor = UIColor.whiteColor().CGColor
        face.layer.masksToBounds = true
        
        initialFrame = background.frame
        initialHeight = initialFrame.size.height
        
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

        
    func setData(user: User) {
            
        face.kf_setImageWithURL(NSURL(string: user.face_url!)!, placeholderImage: nil)
        self.level.text = "\(user.level)"
        self.life.text = "\(user.life)"
        self.id.text = "\(user.id)"
        self.post_count.text = "\(user.post_count)"
        self.user_name.text = "\(user.user_name)"
        
    }
    

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        if scrollView.contentOffset.y < 0 {
            let OffsetY: CGFloat = scrollView.contentOffset.y + scrollView.contentInset.top
            initialFrame.origin.y = OffsetY
            initialFrame.size.height = initialHeight + (OffsetY * -1)
            
            background.frame = initialFrame
        }
        
    }

}

extension ProfileHeaderView {
    class func viewFromNib() -> ProfileHeaderView? {
        let views = UINib(nibName: "ProfileHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)
        for view in views {
            if view.isKindOfClass(self) {
                return view as? ProfileHeaderView
            }
        }
        return nil
    }
}
