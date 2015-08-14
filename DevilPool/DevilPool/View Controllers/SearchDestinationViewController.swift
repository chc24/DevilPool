//
//  SearchDestinationViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/23/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse
import FBSDKMessengerShareKit

class SearchDestinationViewController: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var destLabel: UITextField!
    @IBOutlet weak var searchResults: UITableView!
    @IBOutlet weak var searchResultsHeight: NSLayoutConstraint!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    var queryResults : [PFObject] = []
    
    
    @IBAction func searchDestinations(sender: AnyObject) {
        destLabel.resignFirstResponder()
        if destLabel.text == "" {
            warningLabel.text = "Empty Field"
            warningLabel.hidden = false
        }
        else {
        //MARK Move
            warningLabel.hidden = true
            var query = PFQuery(className: "Post")
            query.whereKey("Destination", containsString: destLabel.text)
            query.includeKey("fromUser")
            
            query.findObjectsInBackgroundWithBlock { (dates: [AnyObject]?, error: NSError?) -> Void in
                
                if let dates = dates as? [PFObject]     {
                   
                    self.queryResults = dates
                    
                }
                
                if self.queryResults.count != 0 {
                    self.noResultsLabel.hidden = true
                    self.searchResults.reloadData()
                    self.searchResultsHeight.constant = CGFloat(self.queryResults.count) * self.searchResults.rowHeight
                    self.view.setNeedsLayout()

                    self.searchResults.hidden = false
                } else {
                    self.noResultsLabel.text = "No results"
                    self.noResultsLabel.hidden = false
                    self.searchResults.hidden = true
                }
                //self.searchResults.reloadData()
                
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search by Destination"
        // Do any additional setup after loading the view.
        self.warningLabel.hidden = true
        self.noResultsLabel.hidden = true
        self.destLabel.delegate = self
        self.destLabel.clearsOnBeginEditing = true
        self.searchResults.dataSource = self
        self.searchResults.delegate = self
        self.searchResults.hidden = true
        
        SearchButton.backgroundColor = UIColor.clearColor()
        SearchButton.layer.cornerRadius = 5
        SearchButton.layer.borderWidth = 1
        SearchButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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

extension SearchDestinationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.destLabel.resignFirstResponder()
        return true
    }
}

extension SearchDestinationViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return # of rows ie. query size
        return queryResults.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("destinationResults", forIndexPath: indexPath) as! PostResultTableViewCell
        var dateHelper = DateHelper()
        //MARK CHANGE
        var current = queryResults[indexPath.row]
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
        
        var current = queryResults[indexPath.row] as PFObject
        var user = current["fromUser"] as! PFUser
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
            
            //ADD PUSH NOTIFICATION HERE
            
            
            //ADD NEW USER TO POSTER'S CARPOOL RELATION
            let user = PFUser.currentUser()
            let relation = current.relationForKey("userPool")
            relation.addObject(user!)
            current.saveInBackground()
            
            //ADD Post to Current User's Carpools
            
            let new_relation = user?.relationForKey("userPools")
            new_relation?.addObject(current)
            user?.saveInBackground()
            
            

            // FACEBOOK REDIRECT
            
            let fbID = current["fromUser"] as! PFUser
            let fburl = fbID["FacebookID"] as! String
            var url = NSURL(string:"fb://profile/\(fburl)")
            
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/\(fburl)")!)
            }
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
}



extension SearchDestinationViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 63
    }
    
}