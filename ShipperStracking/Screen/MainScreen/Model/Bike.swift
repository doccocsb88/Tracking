//
//  User.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation

struct Bike {
   
    var codinate:CLLocationCoordinate2D?
    var store:Store?
    var price:Float?
    var bikeId:String!
    init(json:NSDictionary) {
        bikeId = json["bikeId"] as? String ?? ""
        price = json["price"] as? Float ?? 0.0
        if let storeJson  = json["store"] as? NSDictionary{
            store = Store(json: storeJson)
        }
        if let cordinateDict = json.object(forKey: "cordinate") as? NSDictionary{
            let lat = cordinateDict["lat"] as! Double
            let lng = cordinateDict["lng"] as! Double
            self.codinate = CLLocationCoordinate2DMake(lat, lng)

        }
        
    }
}
