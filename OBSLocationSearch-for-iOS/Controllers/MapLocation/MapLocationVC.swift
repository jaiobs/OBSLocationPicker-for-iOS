//
//  MapLocationVC.swift
//  OBS-LocationPicker-Sample
//
//  Created by MAC-OBS- on 08/09/20.
//  Copyright © 2020 Mac-OBS-09. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapLocationVC: UIViewController {
    
    //Views
    lazy var mapView : MKMapView = {
        let map : MKMapView = MKMapView()
        return map
    }()
    
    lazy var backBtn : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constant().BackArrow), for: .normal)
        button.addTarget(self, action: #selector(backToSearch(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var addressPopView : UIView = {
        var addressView = UIView()
        addressView.layer.cornerRadius = 30.0
        addressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return addressView
    }()
    
    
    lazy var addressLabel : UILabel = {
        let addressText = UILabel()
        addressText.font = UIFont(name: Constant().Font, size: 21.0)
        addressText.textColor = Constant().appColor
        addressText.numberOfLines = 0
        return addressText
    }()
    
    var draggingLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = Constant().labelcolor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        return label
    }()
    
    //Local Variables
    let locationManager = CLLocationManager()
    var selectedPlace : CLLocation?
    var selectedPlaceMark : MKPlacemark?
    var localSearch = MKLocalSearchCompleter()
    var annotationPin = MKPointAnnotation()
    
    //MARK: Controller's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationConfiguration()
    }
    
    //Setting Views With Constraints
    func setUpView(){
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (map) in
            map.edges.equalTo(self.view.snp.edges)
        }
        
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.top.equalTo(self.view.snp.top).offset(40)
        }
        
        
        self.view.addSubview(addressPopView)
        addressPopView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(250)
        }
        
        
        self.addressPopView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressPopView.snp.centerY).offset(-30)
            make.leading.equalTo(self.addressPopView.snp.leading).offset(30)
            make.trailing.lessThanOrEqualTo(self.addressPopView.snp.trailing)
        }
        
        if traitCollection.userInterfaceStyle == .dark{
            addressPopView.backgroundColor = .systemBackground
        }else{
            addressPopView.backgroundColor = .white
        }
        
        addressPopView.addSubview(draggingLabel)
        draggingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressPopView.snp.top).offset(19)
            make.centerX.equalTo(self.addressPopView.snp.centerX)
            make.width.equalTo(45)
            make.height.equalTo(4)
        }
        
    }
}


//MARK: Local Methods and Objc Methods
extension MapLocationVC {
    //Configuratio for location
    func locationConfiguration(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                locationManager.requestAlwaysAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                beginLocationUpdates()
            default:
                break
            }
        } else {
            openSettingApp(message: Constant().AllowOpenSettings)
        }
    }
    
    //open location settings for app
    func openSettingApp(message: String) {
        let alertController = UIAlertController (title: Constant().AppTitle, message:message , preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: NSLocalizedString(Constant().Settings, comment: Constant().Empty), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString(Constant().Cancel, comment: ""), style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //Begin Location Update SetUp
    func beginLocationUpdates(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //Set the selected location on Map
    func renderLocationInMap(_ location : CLLocation){
        let center : CLLocationCoordinate2D?
        if let latitude = selectedPlace?.coordinate.latitude, let longitude = selectedPlace?.coordinate.longitude{
            center = CLLocationCoordinate2DMake(latitude,longitude)
            DispatchQueue.main.async {
                if self.selectedPlaceMark != nil {
                    self.addressLabel.text = self.selectedPlaceMark?.title
                }
            }
        }else{
            center =  CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            
            AppUtils.sharedInstance.geocode(latitude: center!.latitude, longitude: center!.longitude) { (placemark, error) in
                guard let placemark = placemark, error == nil else { return }
                DispatchQueue.main.async {
                    if let city = placemark.locality ,let state = placemark.administrativeArea , let zipCode = placemark.postalCode, let country = placemark.country{
                        self.addressLabel.text = "\(city) \(state) \(zipCode) \(country)"
                    }
                }
            }
        }
        print("Latitude = \(String(describing: center?.latitude)) and Longitude = \(String(describing: center?.longitude))")
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    //Adding Annotations
    func addAnnotations(_ location : CLLocation){
        mapView.removeAnnotation(annotationPin)
        if mapView.annotations.count != 0 {
            print("Existing Annotation Count", mapView.annotations.count)
        }
        annotationPin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if let title = selectedPlaceMark?.title{
            annotationPin.title = title
        }else{
            annotationPin.title = Constant().MyLocation
        }
        mapView.addAnnotation(annotationPin)
    }
    
    //Back Button Action
    @objc func backToSearch(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: CLLocationManagerDelegate
extension MapLocationVC : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates()
        }else{
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            renderLocationInMap(location)
            if let selectedLocation = selectedPlace{
                addAnnotations(selectedLocation)
            }else{
                addAnnotations(location)
            }
        }
    }
}


//MARK: MKMapViewDelegate
extension MapLocationVC : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = Constant().AnnotationView
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        if (annotation.title) != nil{
            annotationView?.image = UIImage(named: Constant().LocationPin)
        }
        if  annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: Constant().LocationPointer)
        }
        
        annotationView?.isDraggable = true
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation?.coordinate {
                print(droppedAt)
                addAnnotations(CLLocation(latitude: droppedAt.latitude, longitude: droppedAt.longitude))
                print(droppedAt)
                AppUtils.sharedInstance.geocode(latitude: droppedAt.latitude, longitude: droppedAt.longitude) { (placemark, error) in
                    guard let placemark = placemark, error == nil else { return }
                    
                    print("address1:====", placemark.name ?? "")
                    print("address2:=====", placemark.subLocality ?? "")
                    print("location:====", placemark.location ?? "")
                    print("District====:",  placemark.subAdministrativeArea ?? "")
                    print("State:======", placemark.administrativeArea ?? "")
                    print("zipcode:=====",placemark.postalCode ?? "")
                    print("country:=====",placemark.country ?? "")
                    DispatchQueue.main.async {
                        let address1 = placemark.name ?? Constant().Empty
                        let address2 = placemark.subLocality ?? Constant().Empty
                        let district = placemark.subAdministrativeArea ?? Constant().Empty
                        let stateCode = placemark.administrativeArea ?? Constant().Empty
                        let zipcode = placemark.postalCode ?? Constant().Empty
                        let country = placemark.country ?? Constant().Empty
                        if address1 == address2{
                            self.addressLabel.text = "\(address1) \(district)\n\(stateCode)-\(zipcode)\n\(country)"
                            self.annotationPin.title = self.addressLabel.text
                        }else {
                            self.addressLabel.text = "\(address1) \(address2)\n\(district)\n \(stateCode)-\(zipcode)\n\(country)"
                            self.annotationPin.title = self.addressLabel.text
                        }
                    }
                }
            }
        }
    }
    
}


