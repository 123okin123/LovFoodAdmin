//
//  CookingEventCell.swift
//  LovFoodAdmin
//
//  Created by Nikolai Kratz on 08.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class CookingEventCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var eventID: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
