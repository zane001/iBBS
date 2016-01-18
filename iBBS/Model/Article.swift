//
//  Article.swift
//  iBBS
//
//  Created by zm on 12/5/15.
//  Copyright © 2015 zm. All rights reserved.
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var group_id: Int32
    @NSManaged var reply_id: Int32
    @NSManaged var flag: String?
    @NSManaged var position: Int32
    @NSManaged var is_top: Bool
    @NSManaged var is_subject: Bool
    @NSManaged var has_attachment: Bool
    @NSManaged var is_admin: Bool
    @NSManaged var title: String?
    @NSManaged var user_id: String?
    @NSManaged var face_url: String?
    @NSManaged var post_time: Int32
    @NSManaged var board_name: String?
    @NSManaged var content: String?
//    @NSManaged var attachment: Attachment
    @NSManaged var previous_id: Int32
    @NSManaged var next_id: Int32
    @NSManaged var threads_previous_id: Int32
    @NSManaged var threads_next_id: Int32
    @NSManaged var reply_count: Int32
    @NSManaged var last_reply_user_id: String?
    @NSManaged var last_reply_time: Int32
}