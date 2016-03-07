//
//  Route.swift
//  TransitApp
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
//import Polyline
//This class is a substitute for a data model. Each instance of it represents an alternative route. 
//I also holds the logic of manipulation and extraction. If I had more time I would have implemented a 
//real data base model and a database handling class. 
class Route {
    
    //MARK: - Properties
    
    var provider = String()
    var properties : String?
    
    var duration = Int()
    var departureTime : NSDate?
    var arrivalTime : NSDate?
    var durationDetail = String()
    var stringPrice : String?
    
    var type = String() {
        didSet {
            changeTypeName()
        }
    }
    
    var price : Price? {
        didSet{
           getPriceForRoute()
        }        
    }
    
    var segments : [Segment]? {
        didSet {
            getRouteDuration()
            getDurationDetail()
            getStartLocationForRoute()
            getEndLocationForRoute()
        }
    }
    

    
    var departureCoordinate : CLLocationCoordinate2D?
    var departureName : String?
    var arrivalCoordinate : CLLocationCoordinate2D?
    var arrivalName: String?
    
    let dateFormatter = NSDateFormatter()

    
    //MARK: - General Conversion Methods
    
    func convertStringToDate(dateString: String) -> NSDate?
    {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let timestamp = dateFormatter.dateFromString(dateString)
        return timestamp
    }
    
    func convertDateIntoStringComponents(date: NSDate) -> String
    {
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        let stamp = "\(hour):\(minute)"
        return stamp
    }

    private func changeTypeName()
    {
        let type = self.type
        switch type{
        case "public_transport":
            self.type = "Public Transport"
        case "car_sharing":
            self.type = "Car Sharing"
        case "private_bike":
            self.type = "Private Bike"
        case "bike_sharing":
            self.type = "Bike Sharing"
        case "taxi":
            self.type = "Taxi"
        default:
            break
        }
    }
    
    //MARK: - Route information retrieval methodes
    
    private func getRouteDuration()
    {
        //Get string timestamps from data
        let nbSegments = segments!.count == 0 ? segments!.count : segments!.count - 1
        let nbStopsOfLastSegment = segments![nbSegments].stops.count == 0 ? segments![nbSegments].stops.count : segments![nbSegments].stops.count - 1
        
        let firstTimeStamp = segments![0].stops[0].datetime
        let lastTimeStamp = segments![nbSegments].stops[nbStopsOfLastSegment].datetime
        
        //Convert string to date
        let departureDate = convertStringToDate(firstTimeStamp)
        let arrivalDate = convertStringToDate(lastTimeStamp)
        
        guard let d1 = departureDate else {return}
        guard let d2 = arrivalDate else {return}
        
        departureTime = d1
        arrivalTime = d2
        duration = Int(d2.timeIntervalSinceDate(d1))
    }
    
    private func getDurationDetail()
    {
        let departure = convertDateIntoStringComponents(departureTime!)
        let arrival = convertDateIntoStringComponents(arrivalTime!)
        durationDetail = "\(departure) -> \(arrival)"
    }
    
    private func getPriceForRoute()
    {
        guard let price = self.price else { stringPrice = "Free!"; return }
        let amount = Float(price.amount)/100
        var currency = price.currency
        if currency == "EUR" {
            currency = "€"
        }
        stringPrice = "\(amount)\(currency)"
    }
    
    private func getStartLocationForRoute()
    {
        let lat = self.segments?.first?.stops.first?.lat
        let lng = self.segments?.first?.stops.first?.lng
        guard let positionLat = lat else { return }
        guard let positionLng = lng else { return }
        
        departureCoordinate = CLLocationCoordinate2D(latitude: Double(positionLat), longitude: Double(positionLng))
        departureName = self.segments?.first?.stops.first?.name
    }
    
    private func getEndLocationForRoute()
    {
        let lat = self.segments?.last?.stops.last?.lat
        let lng = self.segments?.last?.stops.last?.lng
        guard let positionLat = lat else { return }
        guard let positionLng = lng else { return }
        
        arrivalCoordinate = CLLocationCoordinate2D(latitude: Double(positionLat), longitude: Double(positionLng))
        arrivalName = self.segments?.last?.stops.last?.name
    }

    
    //MARK: - Segment information retrieval methodes
    
    func getFirstTimestampForSegment(segment: Segment) -> String
    {
       // let nbStops = segment.stops.count
        let firstTimestamp = segment.stops[0].datetime
        let timestampDate = convertStringToDate(firstTimestamp)
        guard let date = timestampDate else { return ""}
        let timestamp = convertDateIntoStringComponents(date)
        return timestamp
    }
    
    func getLastTimestampForSegment(segment: Segment) -> String
    {
        let nbStops = segment.stops.count - 1
        let lastTimestamp = segment.stops[nbStops].datetime
        let timestampDate = convertStringToDate(lastTimestamp)
        guard let date = timestampDate else { return ""}
        let timestamp = convertDateIntoStringComponents(date)
        return timestamp
    }    
}

struct Price {
    let currency: String
    let amount : Int
}

struct Stop {
    let lat : Float
    let lng : Float
    let datetime : String
    let name : String
    let properties : String
}

struct Segment {
    let name : String
    let num_stops : Int
    let stops : [Stop]
    let travel_mode : String
    let description : String
    let color : String
    let icon_url : String
    let polyline : String
}

struct ProviderAttribute {
    let name : String
    let provider_icon_url : String?
    let disclaimer : String?
    let ios_app_url : String?
    let ios_itunes_url : String?
    let android_package_name : String?
    let display_name : String?
}
