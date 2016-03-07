//
//  InformationExtractor.swift
//  TransitApp
//
//  Created by Elliott Brunet on 04/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import Foundation
import SwiftyJSON

class InformationExtractor {
    
    //MARK:- Properties
    
    private var routes = [Route]()
    private var providerAttributes = [ProviderAttribute]()
    
    var jsonData: JSON? {
        didSet {
            extractInformationFromData(jsonData!){_ in self.notifyController()}
        }
    }
    
    private let url = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
    private var data = NSData()

    //MARK: - Methods
    
    func notifyController(){
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "segueToGeneralResultsVC", object: nil))
    }
    
    func getRoutes() -> [Route]
    {
        getData()
        return routes
    }
    
    func getProviderAttributes() -> [ProviderAttribute]{
        return providerAttributes
    }
    
    func getData(){
        data = NSData(contentsOfURL: url!)!
        jsonData = JSON(data:data)
    }
    
    private func extractInformationFromData(data: JSON, complitionHandler: (success:Bool) -> Void) {
        
        for (index,subJson):(String, JSON) in data {
            
            if index == "routes" {
                
                routes.removeAll()
                
                for (_, subSubJson): (String, JSON) in subJson {
                    
                    let route = Route()

                    getType(subSubJson["type"], route: route)
                    getProvider(subSubJson["provider"], route: route)
                    getSegments(subSubJson["segments"], route: route)
                    getProperties(subSubJson["properties"], route: route)
                    getPrice(subSubJson["price"], route: route)
                    
                    routes.append(route)
                }
                
            }

            if index == "provider_attributes" {
                
                providerAttributes.removeAll()
               
                for (subIndex, subSubJson): (String, JSON) in subJson {
                    
                    let icon = subSubJson["provider_icon_url"].stringValue
                    let disclaimer = subSubJson["disclaimer"].stringValue
                    let ios_app = subSubJson["ios_app_url"].stringValue
                    let ios_itunes = subSubJson["ios_itunes_url"].stringValue
                    let android = subSubJson["android_package_name"].stringValue
                    let displayName = subSubJson["display_name"].stringValue
                    
                    let providerAttribute = ProviderAttribute(name: subIndex, provider_icon_url: icon, disclaimer: disclaimer, ios_app_url: ios_app, ios_itunes_url : ios_itunes, android_package_name: android, display_name: displayName)
                    
                    providerAttributes.append(providerAttribute)
                }
            }
        }
        
        if routes.count > 0 {
            complitionHandler(success: true)
        }
    }
    
    //MARK: - Route information extraction methodes
    
    private func getType(data: JSON, route: Route)
    {
        route.type = data.stringValue
    }
    
    private func getProvider(data: JSON, route: Route)
    {
        route.provider = data.stringValue
    }
    
    private func getProperties(data: JSON, route: Route)
    {
        route.properties = data.stringValue
    }
    
    private func getPrice(data: JSON, route: Route)
    {
        let currency = data["currency"].stringValue
        let stringAmount = data["amount"].stringValue
        guard let amount = Int(stringAmount) else {
            return
        }
        let price = Price(currency: currency, amount: amount)
        route.price = price
    }
    
    private func getSegments(data: JSON, route: Route)
    {
        var segments = [Segment]()
        
        for (_, subjson) in data {
            
            let name = subjson["name"].stringValue
            let num_stops = Int(subjson["num_stops"].double!)
            let stops = getStops(subjson["stops"], route: route)
            let travel_mode = subjson["travel_mode"].stringValue
            let desciption = subjson["description"].stringValue
            let color = subjson["color"].stringValue
            let icon_url = subjson["icon_url"].stringValue
            let polyline = subjson["polyline"].stringValue
            
            let segment = Segment(name: name, num_stops: num_stops, stops: stops, travel_mode: travel_mode, description: desciption, color: color, icon_url: icon_url, polyline: polyline)
            
            segments.append(segment)
        }
        
        route.segments = segments
    }
    
    //Extracting stops for each segment
    private func getStops(data: JSON, route: Route) -> [Stop]
    {
        var stops = [Stop]()
        for (_, subjson) in data {
            
            let lat = subjson["lat"].float!
            let lng = subjson["lng"].float!
            let datetime = subjson["datetime"].stringValue
            let name = subjson["name"].stringValue
            let properties = subjson["properties"].stringValue
            
            let stop = Stop(lat: lat, lng: lng, datetime: datetime, name: name, properties: properties)
            stops.append(stop)
        }
        return stops
    }
}
