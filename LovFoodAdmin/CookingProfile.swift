//
//  CookingProfile.swift
//  LovFood
//
//  Created by Nikolai Kratz on 11.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class CookingProfile {
    var firstName :String?
    var lastName :String?
    var userName :String?
    var email :String?
    
    var profileImageURL :NSURL?
    var profileSmallImageURL :NSURL?
    
    var profileText :String?
    var profileImage :UIImage?
    var smallprofileImage : UIImage?
    var gender :Gender?
    
    var commercial = false
    
    
    init(){}
    
    init(snapshot: FIRDataSnapshot) {
        self.firstName = snapshot.value!["firstname"] as? String
        self.lastName = snapshot.value!["lastname"] as? String
        self.userName = snapshot.value!["username"] as? String
        self.email = snapshot.value!["email"] as? String
        if let profileImageURLString = snapshot.value!["profileImageURL"] as? String {
            self.profileImageURL = NSURL(string: profileImageURLString)
        }
        if let profileSmallImageURLString = snapshot.value!["profileSmallImageURL"] as? String {
            self.profileSmallImageURL = NSURL(string: profileSmallImageURLString)
        }
        if let genderString = snapshot.value!["gender"] as? String {
            switch genderString {
            case "male": gender = .Male
            case "female": gender = .Female
            default: gender = .None
            }
        }
    }
}




public enum Gender :String {
    case Male
    case Female
    case None
}