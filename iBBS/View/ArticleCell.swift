//
//  ArticleCell.swift
//  iBBS
//
//  Created by zm on 12/19/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var post_time: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.9).CGColor
        containerView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}