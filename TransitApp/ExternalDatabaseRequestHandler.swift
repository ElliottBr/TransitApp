//
//  ExternalDatabaseHandler.swift
//  TransitApp
//
//  Created by Elliott Brunet on 04/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//
//This class is just to symbolize that there is a consideration for network calls and such. This class would be called 
//throughout the applications life cycle to make network call and handle their response.
import Foundation
import SwiftyJSON

class ExternalDatabaseRequestHandler {
    
    //MARK: - Singelton
    
    //Only be one instantce of the ExternalDBRH that makes networkcalls
    static let sharedInstance = ExternalDatabaseRequestHandler()
    
    //MARK: - Singelton
    
    private let url = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
    private var data = NSData()
    
    private let infoExtractor = InformationExtractor()
   
    //MARK: - Methods

    //Here we make a call to server and wait for search result response, since the data is already there, we won't do that
    func sendSearchRequestToServer(){
        //once data arrives, we send it to informationExtractor for processing 
        data = NSData(contentsOfURL: url!)!
        infoExtractor.jsonData = JSON(data:data)
    }

}
