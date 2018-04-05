//
//  User.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
class BookInfo{
    static let shared = BookInfo()

    var bikeId:String?
    var code:String?
    func isBooked()->Bool{
        if let bikeId = bikeId, !bikeId.isEmpty else{
            return false
        }
        if let code = code, !code.isEmpty else{
            return false
        }
        return true
    }
    
}
