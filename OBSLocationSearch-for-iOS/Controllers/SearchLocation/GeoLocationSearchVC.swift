//
//  GeoLocationSearchVC.swift
//  OBS-LocationPicker-Sample
//
//  Created by Mac-OBS-09 on 07/09/20.
//  Copyright © 2020 Mac-OBS-09. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GeoLocationSearchVC : UIViewController {
    
    //Views
    //TextField SearchBar
    lazy var locationSearchField : PaddedTextField = {
        let txtFld = PaddedTextField()
        txtFld.attributedPlaceholder = NSAttributedString(string: Constant().SearchPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor : Constant().appColor])
        txtFld.textColor = Constant().appColor
        txtFld.layer.borderWidth = 0
        txtFld.layer.cornerRadius = 10
        txtFld.layer.masksToBounds = true
        txtFld.padding = 18
        txtFld.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        return txtFld
    }()
    
    //TableView
    lazy var searchResultTable : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var searchTimer: Timer?
    var interactionType: String?
    var typeOfVC: String?
    
    // MARK: View controller lifecycle methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Background View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if traitCollection.userInterfaceStyle == .dark {
        }else{
            self.view.backgroundColor = Constant().BgColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: File private
    
    fileprivate func setupView() {
        //Set delegate
        searchCompleter.delegate = self
        
        self.view.addSubview(self.locationSearchField)
        
        self.locationSearchField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(17)
            make.trailing.equalTo(self.view.snp.trailing).offset(-17)
            make.height.equalTo(60)
        }
        
        AppUtils.sharedInstance.addImageInTextFieldRight(textfield: self.locationSearchField, imageName: Constant().Search)
        
        if traitCollection.userInterfaceStyle == .dark{
            
        }else{
            locationSearchField.backgroundColor = .white
        }
        
        self.searchResultTable.register(UINib.init(nibName: Constant().CurrentLocationCell, bundle: nil), forCellReuseIdentifier: Constant().CurrentLocationCell)
        self.searchResultTable.dataSource = self
        self.searchResultTable.delegate = self
        
        self.searchResultTable.tableFooterView = UIView()
        self.searchResultTable.separatorStyle = .none
        
        self.view.addSubview(self.searchResultTable)
        self.searchResultTable.snp.makeConstraints { (make) in
            make.top.equalTo(self.locationSearchField.snp.bottom).offset(5)
            make.leading.equalTo(self.view.snp.leading).offset(10)
            make.trailing.equalTo(self.view.snp.trailing).inset(10)
            make.bottom.equalTo(self.view)
        }
    }
}

//MARK: TextField Delegate
extension GeoLocationSearchVC : UITextFieldDelegate{
    @objc func textFieldDidChange(textField: UITextField){
        if textField.text != "" {
            self.searchCompleter.filterType = .locationsOnly
            searchCompleter.queryFragment = textField.text ?? Constant().Empty
        }else{
            self.searchResults.removeAll()
            self.searchResultTable.reloadData()
        }
    }
}

//MARK: TableView DataSource
extension GeoLocationSearchVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0{
            return 1
        }else{
            let rowCount = searchResults.count + 1
            return rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant().CurrentLocationCell, for: indexPath) as! CurrentLocationCell
            cell.backgroundColor = .clear
            return cell
        }else{
            let searchResult = searchResults[indexPath.row - 1]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = Constant().appColor
            cell.detailTextLabel?.textColor = Constant().appColor
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
        }
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Your Location Selected")
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: Constant().MapLocationVC) as! MapLocationVC
            self.navigationController?.pushViewController(mapVC, animated: true)
        }else{
            let completion = searchResults[indexPath.row - 1]
            
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if let placeMark = response?.mapItems.first?.placemark {
                    print("Latitude=====>" ,placeMark.coordinate.latitude, "Longitude=======>", placeMark.coordinate.longitude )
                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: Constant().MapLocationVC) as! MapLocationVC
                    mapVC.selectedPlace = placeMark.location
                    mapVC.selectedPlaceMark = placeMark
                    self.navigationController?.pushViewController(mapVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: MKLocalSearchCompleterDelegate
extension GeoLocationSearchVC : MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.searchResultTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print("No Results Found")
    }
}

