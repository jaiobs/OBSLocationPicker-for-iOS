//
//  CurrentLocationCell.swift
//  OBSLocationSearch-for-iOS
//
//  Created by MAC-OBS- on 09/09/20.
//  Copyright © 2020 MAC-OBS-. All rights reserved.
//

import UIKit

class CurrentLocationCell: UITableViewCell {

    @IBOutlet weak var currentLocationImage : UIImageView!
    @IBOutlet weak var currentLocationLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
