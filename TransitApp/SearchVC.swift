//
//  SearchVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
import GoogleMaps

protocol SearchVCDelegate {
    func showDatePicker()
    func startSearch()
    func dismissSearchTable()
    func placeInformationIsSet(coordinate : CLLocationCoordinate2D, place: String)
}

class SearchVC: UIViewController  {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    @IBOutlet weak var searchTable: UITableView!
    
    //MARK: - Actions
    
  
    //MARK: - Properties
    
    var delegate: SearchVCDelegate?
    var isSettingDepartureAddress = Bool()
    var placeCoordinate : CLLocationCoordinate2D?
    var placesClient = GMSPlacesClient.sharedClient()
    
    private var searchResults = [String]() {
        didSet{
            searchTable.reloadData()
        }
    }
    
    private var idResults = [String]()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Methods
    //send information to container, and then to map controller
    func sendInformationBackToContainer(place: String)
    {
        guard let coordinate = placeCoordinate else {
            return
        }
        delegate?.placeInformationIsSet(coordinate, place: place)
        delegate?.dismissSearchTable()
    }
    
    
    //MARK: - Search Suggestions
    
    func placeAutocomplete(searchText: String)
    {
        let filter = GMSAutocompleteFilter()
        filter.type = .Geocode
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            self.searchResults.removeAll()
            self.idResults.removeAll()
            for result in results! {
                self.searchResults.append(result.attributedFullText.string)
                guard let placeID = result.placeID else {
                    return
                }
                self.idResults.append(placeID)
            }
        })
    }
    
    func searchPlaceID(placeID: String, complitionHandler: (success:Bool) -> Void) {
        placesClient.lookUpPlaceID(placeID, callback: { (place: GMSPlace?, error: NSError?) -> Void in
            guard error == nil  else {
                print("error during lookup placeID query")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            print(place.coordinate)
            self.placeCoordinate = place.coordinate
            complitionHandler(success: true)
        })
    }
}


//MARK :- UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
    func textFieldDidChange(textField: UITextField) {
        placeAutocomplete(textField.text!)
    }
}


//MARK :- UITableViewDataSource & UITableViewDelegate

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let result = searchResults[indexPath.row]
        searchPlaceID(idResults[indexPath.row]){ _ in
            self.sendInformationBackToContainer(result)}
    } 
}

