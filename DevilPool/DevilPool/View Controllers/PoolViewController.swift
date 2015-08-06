//
//  PoolViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

class PoolViewController: UIViewController {

    @IBOutlet weak var poolBarEnable: UITabBarItem!
    @IBOutlet weak var postTableView: UITableView!
    
    var queryResults : [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Carpools"
        //TODO : move to ParseHelper
        
        var myPools = PFUser.currentUser()!.relationForKey("userPools")
        let find = myPools.query()
        
        find!.findObjectsInBackgroundWithBlock { (pools: [AnyObject]?, error: NSError?) -> Void in
            
            if let pools = pools as? [PFObject]     {
                self.queryResults = pools
            }
            self.postTableView.reloadData()
        }

       
            
            
    
            //display no current posts
            
        
        
        //Check if Current user has any posts or groups committed == query for posts
        
        
        
        //Display Posts
        
        //Display Groups
            
        
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PoolViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

extension PoolViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return # of rows ie. query size
        return queryResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postResults", forIndexPath: indexPath) as! PostResultTableViewCell
        
        //MARK CHANGE
        var dateFormatter = NSDateFormatter()
        var current = queryResults[indexPath.row]
        let onDate = current["onDate"] as! NSDate
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.onDate.text = dateFormatter.stringFromDate(onDate)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var current = queryResults[indexPath.row]
        var relations = current["userPool"] as! PFRelation
        
        //MARK MOVE
        let x = relations.query()
        x!.findObjectsInBackgroundWithBlock { (friends: [AnyObject]?, error: NSError?) -> Void in
            
            if let friends = friends as? [PFUser]     {
                for user in friends {
                    println(user.username)
                }
            }
        }

    }
}
