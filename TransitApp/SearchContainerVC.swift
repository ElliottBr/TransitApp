//
//  SearchContainerVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchContainerVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    
    //Contraint
    @IBOutlet weak var searchTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerBottomContraint: NSLayoutConstraint!    
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    //MARK: - Action
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        if  self.searchTableTopConstraint.constant == 0{
            hideSearchTable()
        }
    }
    
    
    //MARK: - Properties
    
    //Views
    private weak var searchBarVC : SearchBarVC?
    private weak var searchVC : SearchVC?
    private weak var mapVC : MapVC?
    private weak var dateVC: DateInputVC?
    
    //layout parameters
    private var screenHeight = CGFloat()
    private var isMovingSearchVC = false
    
    //To transfer search request
    private let externalDBRHandler = ExternalDatabaseRequestHandler.sharedInstance
    
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideUnnecessaryViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: - Notification
    
    private func registerForNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueToGeneralResultsVC", name: "segueToGeneralResultsVC", object: nil)
    }
    
    
    // MARK: - Layout Views
    
    private func hideUnnecessaryViews()
    {
        getScreenSize()
        moveSearchVC(screenHeight, animate: false)
        moveDatePicker(datePickerHeight.constant, animate: false)
        cancelButton.enabled = false
    }
    
    private func hideSearchTable()
    {
        moveSearchVC(screenHeight, animate: true)
        self.searchVC?.searchField.resignFirstResponder()
        cancelButton.enabled = false
    }
    
    
    private func getScreenSize()
    {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //let screenWidth = screenSize.width
        screenHeight = screenSize.height
    }
    
    private func moveSearchVC(delta: CGFloat, animate: Bool)
    {
        if animate {
            if !isMovingSearchVC {
                isMovingSearchVC = true
                self.view.layoutIfNeeded()
                 UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.searchTableTopConstraint.constant += delta
                    self.view.layoutIfNeeded()
                    }, completion: { (success) -> Void in
                        self.isMovingSearchVC = false
                 })
            }
        }
        else {
            searchTableTopConstraint.constant += delta
        }
        
    }
    
    private func moveDatePicker(delta: CGFloat, animate: Bool)
    {
        if animate {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.datePickerBottomContraint.constant -= delta
                self.view.layoutIfNeeded()
            })
        }
        else {
            datePickerBottomContraint.constant -= delta
        }
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Set relationships between all controllers
        if segue.identifier == "ToSearchBar" {
            guard let dvc = segue.destinationViewController as? SearchBarVC else {
                return
            }
            searchBarVC = dvc
            dvc.delegate = self
        }
        if segue.identifier == "ToSearch" {
            guard let dvc = segue.destinationViewController as? SearchVC else {
                return
            }
            searchVC = dvc
            dvc.delegate = self
        }

        if segue.identifier == "ToMap" {
            guard let dvc = segue.destinationViewController as? MapVC else {
                return
            }
            mapVC = dvc
        }
        if segue.identifier == "ToDate" {
            guard let dvc = segue.destinationViewController as? DateInputVC else {
                return
            }
            dateVC = dvc
            dvc.delegate = self
        }
    }
    
    func segueToGeneralResultsVC(){
        performSegueWithIdentifier("toSearchResults", sender: nil)
    }
    
}


//MARK: - SearchVCDelegate Methods

extension SearchContainerVC: SearchVCDelegate {
    
    func placeInformationIsSet(coordinate: CLLocationCoordinate2D, place: String)
    {
        searchBarVC?.coordinate = coordinate
        searchBarVC?.place = place
    }
    
    func dismissSearchTable()
    {
        hideSearchTable()
    }

}


//MARK: - DateInputVCDelegate Methods

extension SearchContainerVC: DateInputVCDelegate {
    
    func dismissDatePicker()
    {
        moveDatePicker(datePickerHeight.constant, animate: true)
    }
    
    func hasSetDate(date: String)
    {
        searchBarVC!.dateLabel.text = date
        dismissDatePicker()
    }
}

//MARK: - SearchBarVCDelegate Methods

extension SearchContainerVC: SearchBarVCDelegate {
    
    func sendCoordinatesToMap(dep: CLLocationCoordinate2D, arr: CLLocationCoordinate2D)
    {
        guard let map = mapVC else {
            return
        }
        map.polylineCoordinates = (dep, arr)
    }
    
    func showDatePicker()
    {
        if datePickerBottomContraint.constant < 0 {
            moveDatePicker(-datePickerHeight.constant, animate: true)
        }
    }
    
    func startSearch()
    {
        externalDBRHandler.sendSearchRequestToServer()
    }
    
    func showSearchTable()
    {
        cancelButton.enabled = true
        self.searchVC?.searchField.becomeFirstResponder()
        moveSearchVC(-screenHeight, animate: true)      
    }
    
}


