//
//  Store.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct Store: Codable{
    var name:String
    var description:String
    
    init(json:NSDictionary) {
        name  = json["name"] as? String ?? ""
        description = json["description"] as? String ?? ""
    }
    
}
