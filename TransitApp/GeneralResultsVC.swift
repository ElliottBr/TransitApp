//
//  ViewController.swift
//  TransitApp
//
//  Created by Elliott Brunet on 04/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

//Contains the first result view, where all results are presented in a list
class GeneralResultsVC: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var resultsTable: UITableView!
    
    @IBOutlet weak var departureAddressLabel: UILabel!
    @IBOutlet weak var arrivalAddressLabel: UILabel!
    //MARK: - Properties
    
    private let informationExctractor = InformationExtractor()
    
    private var routes = [Route](){
        didSet {
            resultsTable.reloadData()
        }
    }
    private var providerAttributes = [ProviderAttribute]()
    
   
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routes = informationExctractor.getRoutes()
        providerAttributes = informationExctractor.getProviderAttributes()
        setPageTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - Methods
    
    //Retrieve data from json
    private func getRouteInformation()
    {
        routes = informationExctractor.getRoutes()
        providerAttributes = informationExctractor.getProviderAttributes()
    }
    
    private func setPageTitle()
    {
        let departure = routes[3].departureName
        let arrival = routes[3].arrivalName
        
        departureAddressLabel.text = departure!
        arrivalAddressLabel.text = arrival!
        //For convienience - since there is no persistency in the data, this makes it easier. In real situation, we wouldn't save this to NSUserDefaults
        saveStartAddress()
    }
    
    private func saveStartAddress()
    {
        NSUserDefaults.standardUserDefaults().setObject(departureAddressLabel.text, forKey: "departureAddress")
    }
    
    //MARK:- Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "ToRouteDetails" {
            guard let dvc = segue.destinationViewController as? RoutesContainer else {
                return
            }
            dvc.routes = routes
            dvc.selectedRoute = sender as! Int
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension GeneralResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RouteGeneralCell
        cell.transportTypeLabel.text = routes[indexPath.row].type
        cell.durationLabel.text = "\(routes[indexPath.row].duration/60) min"
        cell.durationDetailLabel.text = routes[indexPath.row].durationDetail
        cell.costLabel.text = routes[indexPath.row].stringPrice
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ToRouteDetails", sender: indexPath.row)
    }
    

}

