//
//  AllEventsViewController.swift
//  LovFoodAdmin
//
//  Created by Nikolai Kratz on 08.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase

class AllEventsViewController: UITableViewController {

    
    var cookingEvents = [CookingEvent]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatabaseObserver()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func addDatabaseObserver() {
        let query = ref.child("cookingEvents")
        query.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            if let userId = cookingEvent.userId {
                ref.child("users").child(userId)
                    .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        let profile = CookingProfile(snapshot: snapshot)
                        cookingEvent.profile = profile
                        
                        self.cookingEvents.append(cookingEvent)
                        
                        let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)], withRowAnimation: .Automatic)
                    })
            }

        })
        query.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.removeAtIndex(index!)
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)], withRowAnimation: .Automatic)
         
        })
        query.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.removeAtIndex(index!)
            self.cookingEvents.insert(cookingEvent, atIndex: index!)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)], withRowAnimation: .Automatic)
            
        })
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cookingEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cookingEventCellID", forIndexPath: indexPath) as! CookingEventCell
        cell.title.text = cookingEvents[indexPath.row].title
        cell.eventID.text = cookingEvents[indexPath.row].eventId
        cell.user.text = cookingEvents[indexPath.row].profile?.userName
        cell.eventDate.text = convertNSDateToString(cookingEvents[indexPath.row].eventDate)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        let cookingEvent = cookingEvents[indexPath.row]
        
        let eventDateString = convertNSDateToString(cookingEvent.eventDate)
            
        ref.child("cookingEvents").child(cookingEvent.eventId!).removeValue()
            
        ref.child("cookingEventsByDate").child(eventDateString!).child(cookingEvent.eventId!).removeValue()
        
        ref.child("cookingEventsByHostGender").child(cookingEvent.profile!.gender!.rawValue).child(cookingEvent.eventId!).removeValue()
            
        ref.child("cookingEventsByOccasion").child(cookingEvent.occasion!.rawValue).child(cookingEvent.eventId!).removeValue()
            
        geofireRef.child(cookingEvent.eventId!).removeValue()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
