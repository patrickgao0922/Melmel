//
//  PostsUpdateUitility.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData




class PostsUpdateUtility {
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // UpdatePosts
    func updateAllPosts(completionHandler:() -> Void){
        var posts:[Post] = []
        let apiHelper = APIHelper()
        let coreDataUtility = CoreDataUtility()
        
        
        
        
        apiHelper.getPostsFromAPI { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    
                    //id
                    let id = postEntry["id"] as! Int
                    if !coreDataUtility.checkIdExist(id, entityType: .Post) {
                        let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
                        post.id = id
                        
                        //Date
                        let dateString = postEntry["date"] as! String
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(dateString)
                        //Title
                        post.title = postEntry["title"] as! String
                        
                        //Link
                        post.link = postEntry["link"] as! String
                        
                        //Media
                        
                        post.featured_image_downloaded = false
                        
                        if postEntry["featured_image_url"] != nil {
                            post.featured_image_url = postEntry["thumbnail_url"] as? String
                        }
                        
                        
                        posts.append(post)
                    }
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                print(posts.count)
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
        
    }
    
    
    /* Update discounts */
    func updateDiscounts(completionHandler:() -> Void){
        let apiHelper = APIHelper()
        
        apiHelper.getDiscountsFromAPI { (discountArray, success) in
            if success {
                
                JSONParser.parseDiscountJSONArrayToDiscountArray(discountArray, checkConsistency: true, ifInsertIntoManagedContext: true)

                do {
                    try self.managedObjectContext.save()
                } catch {
                }
            }
            completionHandler()
            
        }// end getPostsFromAPI
    }
    
    func getPreviousPosts(beforeDate:NSDate,excludeId:Int,completionHandler:() -> Void){
        var posts:[Post] = []
        let apiHelper = APIHelper()
        let coreDataUitility = CoreDataUtility()
        
        
        apiHelper.getPreviousPosts(.Post, beforeDate: beforeDate, excludeId: excludeId)
        { (postsArray, success) in
            if success {
                
                // create dispatch group
                
                
                for postEntry in postsArray! {
                    
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
                    
                    
                    //id
                    
                    let id = postEntry["id"] as! Int
                    if !coreDataUitility.checkIdExist(id, entityType: .Post){
                        post.id = id
                        
                        //Date
                        let dateString = postEntry["date"] as! String
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(dateString)
                        //Title
                        post.title = postEntry["title"] as? String
                        
                        //Link
                        post.link = postEntry["link"] as? String
                        
                        //Media
                        
                        if postEntry["featured_image_url"] != nil {
                            post.featured_image_url = postEntry["featured_image_url"] as? String
                        }
                        
                        
                        posts.append(post)
                    }
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
    }
    
    func getPreviousDiscounts(beforeDate:NSDate,excludeId:Int,completionHandler:() -> Void){
        
        let apiHelper = APIHelper()
        
        apiHelper.getPreviousPosts(.Discount, beforeDate: beforeDate, excludeId: excludeId)
        { (postsArray, success) in
            if success {
                
                // create dispatch group
                
                
                for discountEntry in postsArray! {
                    
                    let discount = NSEntityDescription.insertNewObjectForEntityForName("Discount", inManagedObjectContext: self.managedObjectContext) as! Discount
                    
                    
                    
                    discount.id = discountEntry["id"] as! Int
                    
                    //Date
                    let dateString = discountEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = discountEntry["title"] as? String
                    
                    //Link
                    discount.link = discountEntry["link"] as? String
                    
                    //Coordinate and address
                    
                    discount.featured_image_downloaded = false
                    discount.address = discountEntry["address"] as? String
                    
                    
                    let latitudeString = discountEntry["latitude"] as! String
                    let longitudeString = discountEntry["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString)
                    
                    
                    discount.longtitude = Double(longitudeString)
                    
                    if discountEntry["featured_image_url"] != nil {
                        discount.featured_image_url = discountEntry["featured_image_url"] as? String
                    }
                    
                    
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
    }
    
    
    
    
    func fetchPosts() -> [Post] {
        
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors=[dateSort]
        do{
            let results = try managedObjectContext.executeFetchRequest(request) as! [Post]
            
            return results
        }catch {}
        return [Post]()
    }
    
    func fetchDiscounts() -> [Discount] {
        
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Discount", inManagedObjectContext: managedObjectContext)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors=[dateSort]
        do{
            let results = try managedObjectContext.executeFetchRequest(request) as! [Discount]
            
            return results
        }catch {}
        return [Discount]()
    }
    
    
    func getAllDiscounts(completionHandler:(discounts:[Discount])->Void) {
        var discounts = [Discount]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                discounts = JSONParser.parseDiscountJSONArrayToDiscountArray(postsArray, checkConsistency: false, ifInsertIntoManagedContext: false)
                
                print(discounts.count)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(discounts: discounts)
                })
                
            }
            else {}
            
        }
    }
    
    func searchDiscountByKeyWords (keyWords:String, completionHandler:(discounts:[Discount]) -> Void) {
        var discounts = [Discount]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("search",keyWords))
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    let discountDescription = NSEntityDescription.entityForName("Discount", inManagedObjectContext: self.managedObjectContext)
                    let discount = Discount(entity: discountDescription!, insertIntoManagedObjectContext: nil)
                    discount
                    //id
                    discount.id = postEntry["id"] as! Int
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = postEntry["title"] as? String
                    
                    //Link
                    discount.link = postEntry["link"] as? String
                    
                    //Media
                    
                    discount.featured_image_downloaded = false
                    
                    //Address and coordinates
                    discount.address = postEntry["address"] as! String
                    
                    
                    let latitudeString = postEntry["latitude"] as! String
                    let longitudeString = postEntry["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString)
                    //print(discount.latitude)
                    
                    discount.longtitude = Double(longitudeString)
                    
                    if postEntry["featured_image_url"] != nil {
                        discount.featured_image_url = postEntry["thumbnail_url"] as? String
                    }
                    let discountTag = postEntry["brand"] as? String
                    if discountTag != nil {
                        discount.discountTag = discountTag
                    }
                    
                    if let discountCatagories = postEntry["category"] as? NSArray{
                        for catagoryEntry in discountCatagories {
                            if let catagoryId = catagoryEntry as? Int {
                                
                                let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                                if !discount.catagories.contains(catagory) {
                                    discount.catagories.append(catagory)
                                    print (catagory)
                                }
                            }
                        }
                    }
                    
                    discounts.append(discount)
                    
                }//End postsArray Loop
                
                
                
                
                
                print(discounts.count)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(discounts: discounts)
                })
                
            }
            else {}
            
        }
    }
    
    func searchPostsByKeyWords(keyWords:String, completionHandler:(posts:[Post]) -> Void) {
        var posts = [Post]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("search",keyWords))
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Post, params: params) { (postsArray, success) in
            for postEntry in postsArray! {
                
                
                let postDescription = NSEntityDescription.entityForName("Post", inManagedObjectContext: self.managedObjectContext)
                
                let post = Post(entity: postDescription!, insertIntoManagedObjectContext: nil)
                
                //id
                let id = postEntry["id"] as! Int
                post.id = id
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    post.title = postEntry["title"] as! String
                    
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    //Media
                    
                    post.featured_image_downloaded = false
                    
                    if postEntry["featured_image_url"] != nil {
                        post.featured_image_url = postEntry["thumbnail_url"] as? String
                    }
                    
                    
                    posts.append(post)
                
                
            }//End postsArray Loop
            completionHandler(posts: posts)

        }
    }
    
    func getDiscountsForCatagory(){}
    
    func getPostComments(postID:String, completionHandler:(comments:[Comment]) -> Void) {
        let apiHelper = APIHelper()
        var commentsArray = [Comment]()
        
        var params = [(String,String)]()
        params.append(("post",postID))
        params.append(("filter[posts_per_page]","-1"))
        
        apiHelper.getPostsFromAPI(.Comment, params: params) { (commentArray, success) in
            if success {
                print (commentsArray.count)
                print ("--------------------")
                for commentEntry in commentArray!{
                    
                    let comment = Comment()
                    
                    if let name = commentEntry["author_name"] as? String {
                        comment.autherName = name
                    }
                    
                    if let date = commentEntry["date"] as? String {
                        let dateFormatter = DateFormatter()
                        comment.date = dateFormatter.formatDateStringToMelTime(date)
                    }
                    
                    if let content = commentEntry["content_raw"] as? String {
                        comment.content = content
                    }
                    
                    if let avatarDic = commentEntry["author_avatar_urls"] as? Dictionary<String,String>{
                        comment.avatar = avatarDic["96"]!
                    }
                    
                    
                    commentsArray.append(comment)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(comments: commentsArray)
                })
            }
            else{}
        }
    }
    
}


class JSONParser {
    /* postArray: JSON Array
     postType; Type of post
     checkConsistency: if check the posts have already been in core data
     */
    
    static func parseDiscountJSONArrayToDiscountArray(postsArray:NSArray?,checkConsistency:Bool,ifInsertIntoManagedContext:Bool) -> [Discount]{
        let coreDataUtility = CoreDataUtility()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var discounts = [Discount]()
        for postEntry in postsArray! {
            let id = postEntry["id"] as! Int
            if checkConsistency{
                if !coreDataUtility.checkIdExist(id,entityType: .Discount){
                    
                    
                    let discountDescription = NSEntityDescription.entityForName("Discount", inManagedObjectContext: managedObjectContext)
                    var managedObjectContextToBeInserted:NSManagedObjectContext?
                    managedObjectContextToBeInserted = managedObjectContext
                    if !ifInsertIntoManagedContext {
                        managedObjectContextToBeInserted = nil
                    }
                    let discount = Discount(entity: discountDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                    discount
                    //id
                    discount.id = postEntry["id"] as! Int
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = postEntry["title"] as? String
                    
                    //Link
                    discount.link = postEntry["link"] as? String
                    
                    //Media
                    
                    discount.featured_image_downloaded = false
                    
                    //Address and coordinates
                    discount.address = postEntry["address"] as! String
                    
                    
                    let latitudeString = postEntry["latitude"] as! String
                    let longitudeString = postEntry["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString)
                    //print(discount.latitude)
                    
                    discount.longtitude = Double(longitudeString)
                    
                    if postEntry["featured_image_url"] != nil {
                        discount.featured_image_url = postEntry["thumbnail_url"] as? String
                    }
                    
                    let discountTag = postEntry["brand"] as? String
                    if discountTag != nil {
                        discount.discountTag = discountTag
                    }
                    
                    
                    discounts.append(discount)
                }
                
            }// end of checkConsistency
            else {
                let discountDescription = NSEntityDescription.entityForName("Discount", inManagedObjectContext: managedObjectContext)
                var managedObjectContextToBeInserted:NSManagedObjectContext?
                managedObjectContextToBeInserted = managedObjectContext
                if !ifInsertIntoManagedContext {
                    managedObjectContextToBeInserted = nil
                }
                let discount = Discount(entity: discountDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                discount
                //id
                discount.id = postEntry["id"] as! Int
                
                //Date
                let dateString = postEntry["date"] as! String
                let dateFormatter = DateFormatter()
                discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                //Title
                discount.title = postEntry["title"] as? String
                
                //Link
                discount.link = postEntry["link"] as? String
                
                //Media
                
                discount.featured_image_downloaded = false
                
                //Address and coordinates
                discount.address = postEntry["address"] as! String
                
                
                let latitudeString = postEntry["latitude"] as! String
                let longitudeString = postEntry["longtitude"] as! String
                
                discount.latitude = Double(latitudeString)
                //print(discount.latitude)
                
                discount.longtitude = Double(longitudeString)
                
                if postEntry["featured_image_url"] != nil {
                    discount.featured_image_url = postEntry["thumbnail_url"] as? String
                }
                let discountTag = postEntry["brand"] as? String
                if discountTag != nil {
                    discount.discountTag = discountTag
                }
                
                if let discountCatagories = postEntry["category"] as? NSArray{
                    for catagoryEntry in discountCatagories {
                        if let catagoryId = catagoryEntry as? Int {
                            
                            let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                            if !discount.catagories.contains(catagory) {
                                discount.catagories.append(catagory)
                            }
                        }
                    }
                }
                discounts.append(discount)
            }
            
            
        }//End postsArray Loop
        return discounts
    }
}
