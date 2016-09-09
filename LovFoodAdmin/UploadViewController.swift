//
//  ViewController.swift
//  LovFoodAdmin
//
//  Created by Nikolai Kratz on 05.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageToUpload :UIImage?
    var thumbImageToUpload:UIImage?
    
    let imagePicker = UIImagePickerController()
   
    
    @IBAction func imagePressed(sender: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonPressed(sender: UIButton) {
        
        // Load in DB
        let eventImageDBRef = ref.child("eventImages").childByAutoId()

        // Load in Storage
        let thumbImageData :NSData = UIImagePNGRepresentation(thumbImageToUpload!)!
        let imageData :NSData = UIImagePNGRepresentation(imageToUpload!)!
        
        let thumbEventImagesStorageRef = storageRef.child("eventImages/thumb/\(eventImageDBRef.key)")
        let eventImagesStorageRef = storageRef.child("eventImages/full/\(eventImageDBRef.key)")
        
        
       
        eventImagesStorageRef.putData(imageData, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                self.showAlertWith("Error", message: error!.localizedDescription)
            } else {
                let fullImageValues = [
                    "full_url" : String(metadata!.downloadURL()!),
                    "full_Storage_uri" : String(eventImagesStorageRef)
                ]
                

                thumbEventImagesStorageRef.putData(thumbImageData, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        self.showAlertWith("Error", message: error!.localizedDescription)
                    } else {
                        // Load Info in DB
                        var thumbImageValues = [
                            "thumb_url" : String(metadata!.downloadURL()!),
                            "thumb_Storage_uri" : String(thumbEventImagesStorageRef)
                        ]
                        thumbImageValues.update(fullImageValues)
                       
                        
                        eventImageDBRef.updateChildValues(thumbImageValues)
                        eventImageDBRef.updateChildValues(thumbImageValues, withCompletionBlock: { (error, ref) in
                            if (error != nil) {
                            self.showAlertWith("Error", message: error!.localizedDescription)
                            } else {
                            self.showAlertWith("Done", message: "Upload finished!")
                            }
                        })
                       
                    }
                }

                
            }
        }
        
        
        

        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToUpload = resizeImage(pickedImage, newWidth: 1000)
            thumbImageToUpload = resizeImage(pickedImage, newWidth: 200)
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func showAlertWith(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:  nil)
    }
    
    

}





extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
