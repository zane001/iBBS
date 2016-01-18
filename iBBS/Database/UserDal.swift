//
//  UserDal.swift
//
//  Created by zm on 12/24/15.
//

import UIKit
import CoreData
import SwiftyJSON


class UserDal: NSObject {
    
    func addUser(obj: JSON, save: Bool) -> User? {
        
        let context = CoreDataManager.shared.managedObjectContext
        let model = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        
        let user = User(entity: model!, insertIntoManagedObjectContext: context)
        
        if model != nil {
           
            let addUser = self.JSON2Object(obj, user: user)
            
            if(save) {
                CoreDataManager.shared.save()
                
            }
            return addUser
        }
        return nil
    }
    
    func deleteAll() {
        CoreDataManager.shared.deleteTable("User")
    }
    
    func save(){
        let context = CoreDataManager.shared.managedObjectContext
        do {
            try context.save()
        } catch _ {
        }
    }
    
    func getCurrentUser() -> User? {
        
        let request = NSFetchRequest(entityName: "User")
        request.fetchLimit = 1
    
        let result = CoreDataManager.shared.executeFetchRequest(request)
        if let users = result {
            
            if (users.count > 0 ){
                 return users[0] as? User
            }
            return nil
        } else {
            return nil
        }
        
    }
    
    func JSON2Object(obj: JSON, user: User) -> User {
        
        var data = obj
        
        let astro = data["astro"].string
        let face_height = data["face_height"].int16!
        let face_url = data["face_url"].string
        let face_width = data["face_width"].int16!
        let first_login_time = data["first_login_time"].int32!
        let gender = data["gender"].string
        let home_page = data["home_page"].string
        let id = data["id"].string!
        let is_admin = data["is_admin"].bool!
        let is_hide = data["is_hide"].bool!
        let is_online = data["is_online"].bool!
        let is_register = data["is_register"].bool!
        let last_login_ip = data["last_login_ip"].string
        let last_login_time = data["last_login_time"].int32!
        let level = data["level"].string!
        let life =  data["life"].int16!
        let login_count = data["login_count"].int32!
        let msn = data["msn"].string
        let post_count = data["post_count"].int32!
        let qq = data["qq"].string
        let stay_count = data["stay_count"].int32!
        let user_name = data["user_name"].string
        
        user.astro = astro
        user.face_height = face_height
        user.face_url = face_url
        user.face_width = face_width
        user.first_login_time = first_login_time
        user.gender = gender
        user.home_page = home_page
        user.id = id
        user.is_admin = is_admin
        user.is_hide = is_hide
        user.is_online = is_online
        user.is_register = is_register
        user.last_login_ip = last_login_ip
        user.last_login_time = last_login_time
        user.level = level
        user.life = life
        user.login_count = login_count
        user.msn = msn
        user.post_count = post_count
        user.qq = qq
        user.stay_count = stay_count
        user.user_name = user_name
        
        return user
    }
}
