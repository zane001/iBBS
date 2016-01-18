//
//  Utility.swift
//  iBBS
//
//  Created by zm on 12/12/15.
//  Copyright © 2015 zm. All rights reserved.
//

import UIKit

class Utility {
    
    class func formatDate(date: NSDate) -> String {
        let original = NSDateFormatter()
        original.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = original.stringFromDate(date)
        return dateString
    }
    
    //    class func board_name_chinese(name: String) -> String {
    //
    //    }
    
    
}

