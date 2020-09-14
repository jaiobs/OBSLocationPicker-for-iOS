//
//  Constant.swift
//  OBSLocationSearch-for-iOS
//
//  Created by MAC-OBS- on 09/09/20.
//  Copyright © 2020 MAC-OBS-. All rights reserved.
//

import Foundation
import UIKit

class Constant : NSObject{
    //Title
    public let AppTitle = "OBSSearchLocation"
    
    //ViewControllers
    public let GeoLocationSearchVC = "ViewController"
    public let MapLocationVC = "MapLocationVC"
    public let CurrentLocationCell = "CurrentLocationCell"
    
    //Titles and PlaceHolders
    public let NavHeading = "Locations search"
    public let EnterLocation = "EnterLocation"
    public let ChooseOwnLocation = "Choose the location in the map"
    public let SearchPlaceHolder = "Enter location"
    
    //UIColors
    public let appColor =  UIColor(red: 143/255, green: 155/255, blue: 179/255, alpha: 1.0)
    public let BgColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 1.0)
    public let labelcolor = UIColor(red: 228/255, green: 233/255, blue: 242/255, alpha: 1.0)
    
    //Assets Name
    public let Search = "Search"
    public let LocationPointer = "LocationPointer"
    public let LocationPin = "LocationPin"
    public let BackArrow = "BackArrow"
    
    //Alert Messages
    public let AllowOpenSettings = "Allow OBSLocationSearch App to enable Location Services"
    public let Cancel = "Cancel"
    public let Settings = "Settings"
    
    //Other String
    public let Empty = ""
    public let Font = "Poppins"
    public let MyLocation = "My Location"
    
    //Identifiers
    public let AnnotationView = "AnnotationView"
    
    //State Strings Array
    let StateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    let StateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tamil Nadu","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
}
