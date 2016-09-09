//
//  EventImagesViewController.swift
//  LovFoodAdmin
//
//  Created by Nikolai Kratz on 09.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase


private let reuseIdentifier = "ImageCellID"

class EventImagesViewController: UICollectionViewController {

    
    var dbQuery :FIRDatabaseReference!
    
    var images = [EventImageObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        dbQuery = ref.child("eventImages")
        addDatabaseObserver()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    
    
    func addDatabaseObserver() {
        dbQuery.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let eventImageObject = EventImageObject(snapshot: snapshot)
            self.images.append(eventImageObject)
            let index = self.images.indexOf{$0.imageID == eventImageObject.imageID}
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        dbQuery.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let eventImageObject = EventImageObject(snapshot: snapshot)
            let index = self.images.indexOf{$0.imageID == eventImageObject.imageID}
            self.images.removeAtIndex(index!)
            self.collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        dbQuery.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            let eventImageObject = EventImageObject(snapshot: snapshot)
            let index = self.images.indexOf{$0.imageID == eventImageObject.imageID}
            self.images.removeAtIndex(index!)
            self.images.insert(eventImageObject, atIndex: index!)
            self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        
    }
    
    
    // MARK: - Navigation
    
   

    @IBAction func backFromUploadImage(segue :UIStoryboardSegue) {
    
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EventImageCell
        if cell.imageView.image == nil {
            storageRef.child("eventImages/thumb/\(images[indexPath.row].imageID!)").dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error)
                } else {
                    
                    // Data for "images/island.jpg" is returned
                    let image: UIImage! = UIImage(data: data!)
                    cell.imageView.image = image
                    self.images[indexPath.row].thumbImage = image
                    
                }
            }
        }
        cell.tag = indexPath.row
        return cell
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: ((screenwidth - 4)/3), height: (screenwidth - 4)/3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let image = images[indexPath.row]

        let alertController = UIAlertController(title: nil, message: "Do you really want to delete this image?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
    
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            // Create a reference to the file to delete
            let desertRef = storageRef.child("eventImages/full/\(image.imageID!)")
            // Delete the file
            desertRef.deleteWithCompletion { (error) -> Void in
                if (error != nil) {
                   self.showErrorWith(error!.localizedDescription)
                } else {
                    let desertRef = storageRef.child("eventImages/thumb/\(image.imageID!)")
                    // Delete the file
                    desertRef.deleteWithCompletion { (error) -> Void in
                        if (error != nil) {
                            self.showErrorWith(error!.localizedDescription)
                        } else {
                            ref.child("eventImages").child(image.imageID!).removeValue()
                            
                        }
                    }
                }
            }
        }
        alertController.addAction(destroyAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
  
    }
    
    func showErrorWith(message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:  nil)
    }
    
    // MARK: UICollectionViewDelegate
    
    
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
    
    
    
    
}
