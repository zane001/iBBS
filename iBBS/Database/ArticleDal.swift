//
//  ArticleDal.swift
//  iBBS
//
//  Created by zm on 12/12/15.
//  Copyright © 2015 zm. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Optional {
    func valueOrDefault(defaultValue: Wrapped) -> Wrapped {
        switch(self) {
        case .None:
            return defaultValue
        case .Some(let value):
            return value
        }
    }
}

class ArticleDal: NSObject {
    
    func obj2ManagedObject(obj: AnyObject, article: Article) -> Article {
        var data = JSON(obj)
        let id = data["id"].int32!
        let group_id = data["group_id"].int32!
        let reply_id = data["reply_id"].int32!
        let flag = data["flag"].string
        let position = data["position"].int32!
        let is_top = data["is_top"].bool!
        let is_subject = data["is_subject"].bool!
        let has_attachment = data["has_attachment"].bool!
        let is_admin = data["is_admin"].bool!
        let title = data["title"].string
//        let user = data["user"]
        let post_time = data["post_time"].int32!
        let board_name = data["board_name"].string
        let content = data["content"].string
//        let attachment = data["attachment"]
        let previous_id = data["previous_id"].int32
        let next_id = data["next_id"].int32
        let threads_previous_id = data["threads_previous_id"].int32
        let threads_next_id = data["threads_next_id"].int32
        let reply_count = data["reply_count"].int32
        let last_reply_user_id = data["last_reply_user_id"].string
        let last_reply_time = data["last_reply_time"].int32
        let user_id = data["user"]["id"].string
        let face_url = data["user"]["face_url"].string
        
        article.id = id
        article.group_id = group_id
        article.reply_id = reply_id
        article.flag = flag
        article.position = position
        article.is_top = is_top
        article.is_subject = is_subject
        article.has_attachment = has_attachment
        article.is_admin = is_admin
        article.title = title
        article.user_id = user_id
        article.face_url = face_url
        article.post_time = post_time
        article.board_name = board_name
        article.content = content
//        article.attachment = attachment
        if previous_id != nil {
            article.previous_id = previous_id!
        }
        if next_id != nil {
            article.next_id = next_id!
        }
        if threads_previous_id != nil {
            article.threads_previous_id = threads_previous_id!
        }
        if threads_next_id != nil {
            article.threads_next_id = threads_next_id!
        }
        if reply_count != nil {
            article.reply_count = reply_count!
        }
        if last_reply_user_id != nil {
            article.last_reply_user_id = last_reply_user_id!
        }
        if last_reply_time != nil {
            article.last_reply_time = last_reply_time!
        }
        
        return article
    }
    
    func addArticle(obj: AnyObject, save: Bool) {
        let context = CoreDataManager.shared.managedObjectContext
        let model = NSEntityDescription.entityForName("Article", inManagedObjectContext: context)
        let article = Article(entity: model!, insertIntoManagedObjectContext: context)
        
        if model != nil {
            self.obj2ManagedObject(obj, article: article)
        }
        
        if(save) {
            CoreDataManager.shared.save()
        }
    }
    
    func addArticleList(items: [AnyObject]) {
        for item in items {
            self.addArticle(item, save: false)
        }
        CoreDataManager.shared.save()
    }
    
    func deleteAll() {
        CoreDataManager.shared.deleteTable("Article")
    }
    
    func save() {
        let context = CoreDataManager.shared.managedObjectContext
        do {
            try context.save()
        } catch _ {
            
        }
    }
    
    func getArticleList() -> [AnyObject]? {
        let request = NSFetchRequest(entityName: "Article")
        let sort = NSSortDescriptor(key: "last_reply_time", ascending: false)
        request.fetchLimit = 10
        request.sortDescriptors = [sort]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        let result = CoreDataManager.shared.executeFetchRequest(request)
        return result
    }
}