//
//  AppUtils.swift
//  OBSLocationSearch-for-iOS
//
//  Created by MAC-OBS- on 09/09/20.
//  Copyright © 2020 MAC-OBS-. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AppUtils : NSObject {
    
    class var sharedInstance: AppUtils {
        struct Static {
            static let instance = AppUtils()
        }
        return Static.instance
    }
    
    //Add Imageview in Textfield//
    func addImageInTextFieldRight(textfield : PaddedTextField , imageName : String){
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width:65, height: 50))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 35))
        button.center = CGPoint(x: rightView.frame.width / 2, y: rightView.frame.height / 2)
        button.setImage(UIImage(named: imageName), for: .normal)
        rightView.addSubview(button)
        textfield.rightView = rightView
        textfield.rightViewMode = .always
    }
    
    //Get State Names From State Codes
    func longStateName(_ stateCode:String) -> String {
        let dic = NSDictionary(objects: Constant().StateNames, forKeys:Constant().StateCodes as [NSCopying])
        return dic.object(forKey:stateCode) as? String ?? stateCode
    }
    
    //Get the location Address when dragging the annotation
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
}


