//
//  MelGuideTableViewController.swift
//  Melmel
//
//  Created by Work on 30/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

class MelGuideTableViewController: UITableViewController {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var postList = [(Post,UIImage)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Request Posts from Melmel Website
        
        
        
        
        
        // Initialize Posts
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        

        
        
        let postUpdateUtility = PostsUpdateUtility()
        let posts = postUpdateUtility.fetchPosts()
        
        postUpdateUtility.updateAllPosts {
            
        }
        for post in posts {
            if post.featured_media != nil {
                if post.featured_media!.downloaded == nil {
                    print(post.featured_media!.link)
                    let imageDownloader = FileDownloader()
                    imageDownloader.downloadFeaturedImageForPostFromUrlAndSave(post.featured_media!.link!, postId: post.id! as Int) { (image) in
                        post.featured_media!.downloaded = true
                        do {
                            try self.managedObjectContext.save()
                            print("save featured successfully")
                        }catch {
                        }
                        
                        self.postList.append((post,image))
                        
                    }
                } else {
                    let documentDirectory = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
                    
                    let imagePath = documentDirectory.URLByAppendingPathComponent("posts/\(post.id!)/featrued_image.jpg")
                    
                    let image = UIImage(contentsOfFile: imagePath.path!)
                    self.postList.append((post,image!))
                    print("append image successfully")
                }
            }
        }
        
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("melGuideTableViewCell", forIndexPath: indexPath) as! MelGuideTableViewCell
        
        // Configure the cell...
        let postTuple = postList[indexPath.row]
        cell.titleLabel.text = postTuple.0.title!
        cell.featuredImage.image = postTuple.1

        
        
        
        
        
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            //            if posts[path.row].featured_media!.link != nil {
            //                print("There is featuredMedia")
            //            }
            postWebVeiwController.webRequestURLString = postList[path.row].0.link
        }
    }
    
    
    
}
