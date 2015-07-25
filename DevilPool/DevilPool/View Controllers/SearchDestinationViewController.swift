//
//  SearchDestinationViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/23/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse

class SearchDestinationViewController: UIViewController {
    
    @IBOutlet weak var destLabel: UITextField!
    @IBOutlet weak var searchResults: UITableView!
    
    var queryResults : [PFObject] = []
    
    @IBAction func searchDestinations(sender: AnyObject) {
        var query = PFQuery(className: "Post")
        query.whereKey("Destination", containsString: destLabel.text)
        query.includeKey("fromUser")
        query.findObjectsInBackgroundWithBlock { (dates: [AnyObject]?, error: NSError?) -> Void in
            
            if let dates = dates as? [PFObject] {
                println("lalala")
                println(dates)
                self.queryResults = dates
                
            }
            
            self.searchResults.reloadData()
            
            
        }
        println(self.queryResults)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.destLabel.delegate = self
        self.searchResults.dataSource = self
        self.searchResults.delegate = self
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResults", forIndexPath: indexPath) as! SearchResultTableViewCell
        
        // Current Parse User on Row
        var current = queryResults[indexPath.row]
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        
        let fromDate = current["fromTime"] as! NSDate
        let toDate = current["toTime"] as! NSDate
        cell.searchFromTime.text = dateFormatter.stringFromDate(fromDate)
        cell.searchToTime.text = dateFormatter.stringFromDate(toDate)
        
        let onDate = current["onDate"] as! NSDate
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.searchToDate.text = dateFormatter.stringFromDate(onDate)
        
        return cell
    }
}



extension SearchDestinationViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}