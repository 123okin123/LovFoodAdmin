//
//  eventImageObject.swift
//  LovFood
//
//  Created by Nikolai Kratz on 06.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class EventImageObject {
    
    let thumbURL :String?
    let fullURL :String?
    
    let thumbStorageURI :String?
    let fullStrorageURI :String?
    
    let imageID :String?
    
    var thumbImage :UIImage?
    var fullImage :UIImage?
    
    
    init(thumbURL :String, fullURL :String, imageID :String, thumbStorageURI :String, fullStrorageURI :String) {
        self.thumbURL = thumbURL
        self.fullURL = fullURL
        self.imageID = imageID
        self.thumbStorageURI = thumbStorageURI
        self.fullStrorageURI = fullStrorageURI
    }
    init(snapshot: FIRDataSnapshot) {
        self.thumbURL = snapshot.value?["thumb_url"] as? String
        self.fullURL = snapshot.value?["full_url"] as? String
        self.imageID = snapshot.key
        self.thumbStorageURI = snapshot.value?["thumb_Storage_uri"] as? String
        self.fullStrorageURI = snapshot.value?["full_Storage_uri"] as? String
    }
    
    
}

