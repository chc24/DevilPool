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
    @IBOutlet weak var postTableViewHeight: NSLayoutConstraint!
    
    // View References
    var overlayView: UIView!
    var popupView: UIView!
    
    // UIKit Dynamics
    var snapBehavior : UISnapBehavior!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var gestureRecognizer: UIPanGestureRecognizer!
    var gravityBehavior: UIGravityBehavior!
    
    var queryResults : [PFObject] = []
    
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        postTableViewHeight.constant = CGFloat(postTableView.visibleCells().count) * postTableView.rowHeight
    ////        self.view.setNeedsLayout()
    //    }
    
    @IBAction func RefreshButton(sender: AnyObject) {
        populateTable()
    }
    
    func redrawView() {
        self.postTableViewHeight.constant = CGFloat(queryResults.count) * self.postTableView.rowHeight
        self.view.setNeedsDisplay()
    }
    func populateTable() {
        ParseHelper.findUserPosts(PFUser.currentUser()!, completionBlock: { (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let error = error {
                //error handling
            }
            if let results = results as? [PFObject] {
                self.queryResults = results
                self.postTableView.reloadData()
                self.redrawView()
                
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        self.title = "My Carpools"
        //TODO : move to ParseHelper
        
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        populateTable()
        
        //display no current posts
        
        
        
        //Check if Current user has any posts or groups committed == query for posts
        
        
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
    
    func presentTransaction() {
        // Add gesture recognizer to detect touches
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Present TransactionView (loaded from separate interface file)
        popupView = NSBundle.mainBundle().loadNibNamed("PostView", owner: self, options: nil)[0] as! UIView
        popupView.center = CGPointMake(-300, -300)
        self.view.addSubview(popupView)
        
        // Load and add overlay view
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.darkGrayColor()
        overlayView.alpha = 0.0
        overlayView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.insertSubview(overlayView, atIndex: view.subviews.count-1)
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .Width, relatedBy: .Equal,
            toItem: overlayView.superview, attribute: .Width,
            multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .Height, relatedBy: .Equal,
            toItem: overlayView.superview, attribute: .Height,
            multiplier: 1, constant: 0))
        
        // Force Layout pass, so that adding of the background view is not animated
        view.layoutIfNeeded()
        
        // Animate popover onto screen, blend in overlay
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
            self.popupView.center = self.view.center
            self.overlayView.alpha = 0.85
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                self.snapBehavior = UISnapBehavior(item: self.popupView, snapToPoint: self.view.center)
                self.animator.addBehavior(self.snapBehavior)
        })
    }
    
    
}

extension PoolViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 86
    }
}

extension PoolViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return # of rows ie. query size
        return queryResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postResults", forIndexPath: indexPath) as! PostResultTableViewCell
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
        
        var current = queryResults[indexPath.row]
        var relations = current["userPool"] as! PFRelation
        
        //        self.presentTransaction()
        //        //MARK MOVE
        //        let x = relations.query()
        //        x!.findObjectsInBackgroundWithBlock { (friends: [AnyObject]?, error: NSError?) -> Void in
        //
        //            if let friends = friends as? [PFUser]     {
        //                for user in friends {
        //                    println(user.username)
        //                }
        //            }
        //        }
        
    }
}
