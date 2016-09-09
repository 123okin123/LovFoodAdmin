//
//  CookingEvent.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

public class CookingEvent {
    
    var title :String?
    var description :String?
    var profile :CookingProfile?
    var eventId :String?
    var userId :String?
    var eventDate: NSDate?
    var coordinates: CLLocationCoordinate2D?
    var image :UIImage?
    var imageURL :NSURL?

    
    var occasion :Occasion?
    
    var price :Double?
    
    
    var attendeesCount :Int?
    var usesVideo = false
    
    init() {}
    
    init(title: String, description: String, profile: CookingProfile, userId :String, eventId : String, eventDate: NSDate, occasion :Occasion, coordinates: CLLocationCoordinate2D) {
        self.title = title
        self.description = description
        self.userId = userId
        self.eventId = eventId
        self.profile = profile
        self.eventDate = eventDate
        self.occasion = occasion
        self.coordinates = coordinates
    }
    init(snapshot: FIRDataSnapshot) {
        self.title = snapshot.value?["title"] as? String
        self.description = snapshot.value?["description"] as? String
        self.userId = snapshot.value?["userId"] as? String
        self.eventId = snapshot.key
        self.eventDate = convertStringToNSDate(snapshot.value?["eventDate"] as? String)
        let latitude = snapshot.value?["coordinates"]??["lat"] as? Double
        let longitude = snapshot.value?["coordinates"]??["long"] as? Double
        if latitude != nil && longitude != nil {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        if let imageURLString = snapshot.value!["imageURL"] as? String {
            self.imageURL = NSURL(string: imageURLString)
        }
        if let occasionRawValue = snapshot.value?["occasion"] as? String {
            switch occasionRawValue {
            case "CandleLightDinner": occasion = .CandleLightDinner
            case "CookingTogether": occasion = .CookingTogether
            case "CommercialDining": occasion = .CommercialDining
            default: break
            }
        }
    }
    
    
    
}



public func convertStringToNSDate(string: String?) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    var date :NSDate?
    if string != nil {
        date = dateFormatter.dateFromString(string!)
    }
    return date
}

public func convertNSDateToString(date: NSDate?) -> String? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    var string :String?
    if date != nil {
        string = dateFormatter.stringFromDate(date!)
    }
    return string
}

public func convertStringToNSDateTime(string: String?) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    var date :NSDate?
    if string != nil {
        date = dateFormatter.dateFromString(string!)
    }
    return date
}

public func convertNSDateTimeToString(date: NSDate?) -> String? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    var string :String?
    if date != nil {
        string = dateFormatter.stringFromDate(date!)
    }
    return string
}



public enum Occasion :String {
    case CandleLightDinner
    case CookingTogether
    case CommercialDining
}








