//
//  User.swift
//  iBBS
//
//  Created by zm on 12/5/15.
//  Copyright © 2015 zm. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var user_name: String!
    @NSManaged var face_url: String?
    @NSManaged var face_width: Int16
    @NSManaged var face_height: Int16
    @NSManaged var gender: String?
    @NSManaged var astro: String?
    @NSManaged var life: Int16
    @NSManaged var qq: String?
    @NSManaged var msn: String?
    @NSManaged var home_page: String?
    @NSManaged var level: String
    @NSManaged var is_online: Bool
    @NSManaged var post_count: Int32
    @NSManaged var last_login_time: Int32
    @NSManaged var last_login_ip: String?
    @NSManaged var is_hide: Bool
    @NSManaged var is_register: Bool
    @NSManaged var first_login_time: Int32
    @NSManaged var login_count: Int32
    @NSManaged var is_admin: Bool
    @NSManaged var stay_count: Int32

}