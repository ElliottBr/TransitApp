//
//  DetailRouteContentVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 06/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
//Contains all the logic for the bottom part of the detailed route view (everything but the map).
class DetailRouteContentVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var routeTable: UITableView!
    
    //MARK:- Properties
    
    var pageIndex:Int!
    var departureAddress = NSUserDefaults.standardUserDefaults().stringForKey("departureAddress")
    var specificRoute = Route()
    var routes = [Route]()
    
    //MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

//MARK:- UITableViewDataSource & UITableViewDelegate

extension DetailRouteContentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specificRoute.segments!.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GeneralInfoCell", forIndexPath: indexPath) as! RouteGeneralCell
            cell.transportTypeLabel.text = specificRoute.type
            cell.durationLabel.text = "\(specificRoute.duration/60) min"
            cell.durationDetailLabel.text = specificRoute.durationDetail
            cell.costLabel.text = specificRoute.stringPrice
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
            cell.startTimeLabel.text = specificRoute.getFirstTimestampForSegment(specificRoute.segments![indexPath.row - 1])
            cell.stopTimeLabel.text = specificRoute.getLastTimestampForSegment(specificRoute.segments![indexPath.row - 1])
            cell.startAddressLabel.text =  departureAddress// specificRoute.segments![indexPath.row - 1].stops.first!.name
            cell.stopAddressLabel.text = specificRoute.segments![indexPath.row - 1].stops.last!.name
            cell.extraInformationLabel.text = specificRoute.segments![indexPath.row - 1].travel_mode
            if specificRoute.type == "Public Transport"{
                cell.detailExtraInformation.text = specificRoute.segments![indexPath.row - 1].name
            } else {
                cell.detailExtraInformation.text = ""
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
            cell.startTimeLabel.text = specificRoute.getFirstTimestampForSegment(specificRoute.segments![indexPath.row - 1])
            cell.stopTimeLabel.text = specificRoute.getLastTimestampForSegment(specificRoute.segments![indexPath.row - 1])
            cell.startAddressLabel.text =  specificRoute.segments![indexPath.row - 1].stops.first!.name
            cell.stopAddressLabel.text = specificRoute.segments![indexPath.row - 1].stops.last!.name
            cell.extraInformationLabel.text = specificRoute.segments![indexPath.row - 1].travel_mode
            if specificRoute.type == "Public Transport"{
                cell.detailExtraInformation.text = specificRoute.segments![indexPath.row - 1].name
            } else {
                cell.detailExtraInformation.text = ""
            }
            
           return cell
        }
    }
    
    func configureTableView() {
        routeTable.rowHeight = UITableViewAutomaticDimension
        routeTable.estimatedRowHeight = 300
    }
    
}
