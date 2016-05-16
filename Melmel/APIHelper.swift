//
//  File.swift
//  Melmel
//
//  Created by Work on 2/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation

class APIHelper {
    let postUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/posts/"
    let discountUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/discounts/"
    let mediaUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/media/"
    
    let postLastUpdateTimeKey = "postLastUpdateTime"
    let discountLastUpdateTimeKey = "discountLastUpdateTime"
    
    let session = NSURLSession.sharedSession()
    
    
    
    
    
    func getPostsFromAPI (postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let postUrl:NSURL
        
        if let lastUpdateTimeObject = NSUserDefaults.standardUserDefaults().objectForKey(postLastUpdateTimeKey) {
            let lastUpdateTime = lastUpdateTimeObject as! NSDate
            let dateFormatter = DateFormatter()
            postUrl = NSURL(string: postUrlPathString+"?after=\(dateFormatter.formatDateToDateString(lastUpdateTime))")!
            print(dateFormatter.formatDateToDateString(lastUpdateTime))
            
        } else {
            postUrl = NSURL(string: postUrlPathString)!
        }
        
        
        
        session.dataTaskWithURL(postUrl){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            if let responseData = data {
                let date = NSDate()
                NSUserDefaults.standardUserDefaults().setObject(date, forKey: postLastUpdateTimeKey)
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let postsArray = json as? NSArray{
                        postsAcquired(postsArray:postsArray,success:true)
                    }
                    else {
                        postsAcquired(postsArray:nil,success:false)
                    }
                } catch {
                    postsAcquired(postsArray:nil,success:false)
                    print("could not serialize!")
                }
            }
        }.resume()
        
        
    }
    
    // Get discounts from API
    func getDiscountsFromAPI (postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let postUrl:NSURL
        
        if let lastUpdateTimeObject = NSUserDefaults.standardUserDefaults().objectForKey(discountLastUpdateTimeKey) {
            let lastUpdateTime = lastUpdateTimeObject as! NSDate
            let dateFormatter = DateFormatter()
            postUrl = NSURL(string: postUrlPathString+"?after=\(dateFormatter.formatDateToDateString(lastUpdateTime))")!
            print(dateFormatter.formatDateToDateString(lastUpdateTime))
            
        } else {
            postUrl = NSURL(string: postUrlPathString)!
        }
        
        
        
        session.dataTaskWithURL(postUrl){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            if let responseData = data {
                let date = NSDate()
                NSUserDefaults.standardUserDefaults().setObject(date, forKey: discountLastUpdateTimeKey)
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let postsArray = json as? NSArray{
                        postsAcquired(postsArray:postsArray,success:true)
                    }
                    else {
                        postsAcquired(postsArray:nil,success:false)
                    }
                } catch {
                    postsAcquired(postsArray:nil,success:false)
                    print("could not serialize!")
                }
            }
            }.resume()
        
        
    }
    
    
    
    /* Get All Media */
    func getAllMediaFromAPI(mediaAcquired:(mediaArray:NSArray?,success:Bool) -> Void){
        let url = NSURL(string: mediaUrlPathString)
        session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if let responseData = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let mediaList = json as? NSArray{
                        mediaAcquired(mediaArray:mediaList,success:true)
                    }
                    else {
                        mediaAcquired(mediaArray: nil, success: false)
                    }
                } catch{
                    mediaAcquired(mediaArray: nil, success: false)
                }
            }
        }.resume()
    }
    
    /* GetMediaById */
    func getMediaById(mediaId:Int, mediaAcquired:(mediaDictionary:Dictionary<String,AnyObject>?,success:Bool) -> Void){
        // Request featured media
        let mediaUrl = NSURL(string:mediaUrlPathString + "\(mediaId)/")!
        session.dataTaskWithURL(mediaUrl, completionHandler: { (responseData:NSData?, mediaResponse:NSURLResponse?, mediaError:NSError?) in
            do{
                let featuredMediaData = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.AllowFragments)
                
                if let json = featuredMediaData as? Dictionary<String,AnyObject>{
                    mediaAcquired(mediaDictionary:json,success:true)
                }
                else {
                    mediaAcquired(mediaDictionary:nil,success:false)
                }
            }catch {
                mediaAcquired(mediaDictionary:nil,success:false)
            }
        }).resume()
        
    }
}