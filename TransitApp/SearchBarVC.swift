//
//  SearchVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
import GoogleMaps

protocol SearchBarVCDelegate {
    func showSearchTable()
    func showDatePicker()
    func startSearch()
    func sendCoordinatesToMap(dep : CLLocationCoordinate2D, arr: CLLocationCoordinate2D)
}

class SearchBarVC: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //MARK: - Actions
    
    @IBAction func departurePressed(sender: UIButton) {
        delegate?.showSearchTable()
        isSettingDepartureAddress = true
    }

    @IBAction func arrivalPressed(sender: UIButton) {
        delegate?.showSearchTable()
        isSettingDepartureAddress = false
    }
    
    @IBAction func chooseDate(sender: UIButton) {
        //self.resignFirstResponder()
        self.view.endEditing(true)
        delegate?.showDatePicker()
    }
    
    @IBAction func startSearch(sender: UIButton) {
        delegate?.startSearch()
    }
    
    @IBAction func switchPlaces(sender: UIButton) {
        let temp = departureLabel.text
        departureLabel.text = arrivalLabel.text
        arrivalLabel.text = temp
    }
    
    
    //MARK: - Properties
    
    var delegate: SearchBarVCDelegate?
    var isSettingDepartureAddress = Bool()
    
    var departureCoordinate : CLLocationCoordinate2D?
    var arrivalCoordinate : CLLocationCoordinate2D?
    
    var coordinate : CLLocationCoordinate2D? {
        didSet{
            if isSettingDepartureAddress {
                departureCoordinate = coordinate!
            } else {
                arrivalCoordinate = coordinate!
            }
            sendCoordinatesToMap()
        }
    }
    
    var place : String? {
        didSet{
            if isSettingDepartureAddress {
                departureLabel.text = place
            } else {
                arrivalLabel.text = place
            }
        }
    }

    
     //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Methods
    
    func sendCoordinatesToMap()
    {
        guard let depCord = departureCoordinate else {
            return
        }
        guard let arrCord = arrivalCoordinate else {
            return
        }
        let path = GMSMutablePath()
        path.addCoordinate(depCord)
        path.addCoordinate(arrCord)

        delegate?.sendCoordinatesToMap(depCord, arr: arrCord)
    }

}
