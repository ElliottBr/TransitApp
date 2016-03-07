//
//  mapVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
import GoogleMaps
import Polyline

class MapVC: UIViewController {
    
    //MARK: - Properties
    
    
    var mapView = GMSMapView()
    
    var polylineCoordinates : (CLLocationCoordinate2D, CLLocationCoordinate2D)?
    {
        didSet {
            guard let coordinates = polylineCoordinates else { return }
            drawPolyline(coordinates.0, arr: coordinates.1)
        }
    }
    
    var polylineArray = [String]() {
        didSet {
            drawEncodedPolyline(polylineArray)
        }
    }
    
    var moveToCurrentLocation = true
    
    private let locationManager = CLLocationManager()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup location tracking
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.view = mapView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Map Functions
    
    private func drawPolyline(dep : CLLocationCoordinate2D, arr: CLLocationCoordinate2D)
    {
        mapView.clear()
        let path = GMSMutablePath()
        path.addCoordinate(dep)
        path.addCoordinate(arr)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.map = mapView
        repositionMap(dep, arr: arr, offset: true)
    }
    
    private func drawEncodedPolyline(polylineArray : [String])
    {
        mapView.clear()
        var pathArray = [GMSPath]()
        var decodedCoordinates = [[CLLocationCoordinate2D]]()
        
        for polyline in polylineArray {
            let aPath = GMSPath(fromEncodedPath:polyline)
            guard let path = aPath else { return }
            pathArray.append(path)
            
            let encodedPolyline = Polyline(encodedPolyline: polyline)
            guard let coordinates = encodedPolyline.coordinates else { return }
            decodedCoordinates.append(coordinates)
        }
        
        for path in pathArray {
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 2
            polyline.map = mapView
        }
        
        let coordinate1 = decodedCoordinates.first?.first
        let coordinate2 = decodedCoordinates.last?.last
        
        repositionMap(coordinate1, arr: coordinate2, offset:false)
    }
    
    private func repositionMap(dep: CLLocationCoordinate2D?, arr: CLLocationCoordinate2D?, offset:Bool)
    {
        var topMargin : CGFloat = 80
        if offset {
            topMargin = 140
        }
        guard let depCoordinates = dep else { return }
        guard let arrCoordinates = arr else { return }
        let bounds = GMSCoordinateBounds(coordinate: depCoordinates, coordinate: arrCoordinates)
        let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsetsMake(topMargin, 30, 30, 30))
        
        self.mapView.animateToCameraPosition(camera!)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if moveToCurrentLocation {
            guard let location = locations.first else { return }
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}

