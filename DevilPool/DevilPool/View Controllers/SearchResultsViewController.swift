//
//  SearchResultsViewController.swift
//  DevilPool
//
//  Created by Administrator on 8/13/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var results: [PFObject] = []
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var resultHeight: NSLayoutConstraint!
    @IBOutlet weak var numResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if results.count > 1 {
            numResultLabel.text = String(results.count) + " results:"
        }
        else if results.count == 0 {
            numResultLabel.text = String(results.count) + "results"
        }
        else {
            numResultLabel.text = String(results.count) + " result"
        }
        
        self.resultHeight.constant = CGFloat(results.count) * 75
        self.view.setNeedsDisplay()
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


extension SearchResultsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return # of rows ie. query size
        return results.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postResults", forIndexPath: indexPath) as! PostResultTableViewCell
        
        // Current Parse User on Row
        var dateHelper = DateHelper()
        //MARK CHANGE
        var current = results[indexPath.row]
        let parsedate = current["onDate"] as! NSDate
        let month = dateHelper.getMonthFromDate(parsedate)
        let day = dateHelper.getDateFromDate(parsedate)
        let ft = current["fromTime"] as! NSDate
        let tt = current["toTime"] as! NSDate
        let destination = current["Destination"] as! String
        
        cell.monthLabel.text = month
        cell.onDate.text = day
        cell.fromTimeLabel.text = dateHelper.makeShortTime(ft)
        cell.toTimeLabel.text = dateHelper.makeShortTime(tt)
        cell.destinationLabel.text = destination
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var current = results[indexPath.row] as PFObject
        println(current)
        var user = current["fromUser"] as! PFUser
        user.fetch()
        var username = user.username
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        
        let fromDate = dateFormatter.stringFromDate(current["fromTime"] as! NSDate)
        let toDate = dateFormatter.stringFromDate(current["toTime"] as! NSDate)
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let onDate = dateFormatter.stringFromDate(current["onDate"] as! NSDate)
        
        let message = "Ask " + username! + " if he wants to carpool!"
        var refreshAlert = UIAlertController(title: "Confirmation", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Request Carpool", style: .Default, handler: { (action: UIAlertAction!) in
            
            //TODO ADD PUSH NOTIFICATION HERE
            
            
            //ADD NEW USER TO POSTER'S CARPOOL RELATION
            let currentuser = PFUser.currentUser()
            let relation = current.relationForKey("userPool")
            relation.addObject(currentuser!)
            current.saveInBackground()
            
            //ADD Post to Current User's Carpools
            
            let new_relation = currentuser?.relationForKey("userPools")
            new_relation?.addObject(current)
            currentuser?.saveInBackground()
            
            
            
            //FACEBOOK REDIRECT
            
            let fbID = current["fromUser"] as! PFUser
            let fburl = fbID["FacebookID"] as! String
            let link = "fb://profile/" + fburl
            let link2 = "fb://profile?app_scoped_user_id=" + fburl
            var url = NSURL(string: link)
            
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(NSURL(string: link2)!)
            } else {
                println("opened in safari")
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/\(fburl)")!)
            }
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    //Cancel Results
    @IBAction func dismissAction (sender : AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}



extension SearchResultsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
}
