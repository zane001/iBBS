//
//  Board.swift
//  iBBS
//
//  Created by zm on 12/5/15.
//  Copyright © 2015 zm. All rights reserved.
//

import Foundation
import CoreData

@objc(Board)
public class Board: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var manager: String?
    @NSManaged var board_description: String?
    @NSManaged var board_class: String?
    @NSManaged var section: String?
    @NSManaged var post_today_count: Int32
    @NSManaged var threads_today_count: Int32
    @NSManaged var post_threads_count: Int32
    @NSManaged var post_all_count: Int32
    @NSManaged var is_read_only: Bool
    @NSManaged var is_no_reply: Bool
    @NSManaged var allow_attachment: Bool
    @NSManaged var allow_anonymous: Bool
    @NSManaged var allow_outgo: Bool
    @NSManaged var allow_post: Bool
    @NSManaged var user_online_count: Int32
    @NSManaged var user_online_max_count: Int32
    @NSManaged var user_online_max_time: Int32
}