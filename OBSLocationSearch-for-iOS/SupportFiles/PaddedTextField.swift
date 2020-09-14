//
//  PaddedTextField.swift
//  OBSLocationSearch-for-iOS
//
//  Created by MAC-OBS- on 09/09/20.
//  Copyright © 2020 MAC-OBS-. All rights reserved.
//

import Foundation
import UIKit

//Custom Padded Textfield Class//
class PaddedTextField: UITextField {
    @IBInspectable var padding: CGFloat = 0
    open var paddingSpace : CGFloat?
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
}
