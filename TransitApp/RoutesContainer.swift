//
//  DetailsRoutesContainer.swift
//  TransitApp
//
//  Created by Elliott Brunet on 06/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

class RoutesContainer: UIViewController {
    
    //MARK: - Properties
    
    var routes = [Route]()
    var selectedRoute : Int!
    
    private weak var mapVC : MapVC?
    private weak var pageContainer : PageContainerVC?

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        routeHasChanged(selectedRoute)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    //Set relationships between all controllers
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToMap" {
            guard let dvc = segue.destinationViewController as? MapVC else {
                return
            }
            mapVC = dvc
            mapVC?.moveToCurrentLocation = false
        }
        if segue.identifier == "toRouteDetails" {
            guard let dvc = segue.destinationViewController as? PageContainerVC else {
                return
            }
            pageContainer = dvc
            pageContainer?.routes = routes
            pageContainer?.selectedRoute = selectedRoute
            pageContainer?.delegate = self
            
        }
    }
}

// MARK: - PageContainerVCDelegate

extension RoutesContainer: PageContainerVCDelegate {
    func routeHasChanged(newIndex: Int)
    {
        var polylineArray = [String]()
        for seg in routes[newIndex].segments! {
            polylineArray.append(seg.polyline)
        }
        mapVC?.polylineArray = polylineArray
    }
}
