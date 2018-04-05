//
//  User.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
class RentInfo{
    static let shared = RentInfo()

    var bikeId:String?
    var code:String?
    func isBooked()->Bool{
        guard let bikeId = bikeId, !bikeId.isEmpty else{
            return false
        }
        guard let code = code, !code.isEmpty else{
            return false
        }
        return true
    }
    
}
