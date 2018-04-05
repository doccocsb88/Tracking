//
//  Constants.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct K {
    struct ProductionServer {
        static let baseURL = "https://demo7436242.mockable.io/"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
enum ErrorMessage: String{
    case noData = "Can not load data from server. Please try again!"
    case unknow = "Error message"
}
