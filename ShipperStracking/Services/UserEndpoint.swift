//
//  UserEndpoint.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Alamofire
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
enum UserEndpoint: APIConfiguration {
    
    case listbike
    case payment(cardNumber:String, expiryDate:String,cardHolder:String,ccv_number:String)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .listbike:
            return .get
        case .payment:
            return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .listbike:
            return "/listbike"
        case .payment(let cardNumber, let expiryDate, let cardHolder, let ccv_number):
            return "/payment/\(cardNumber)/\(expiryDate)/\(cardHolder)/\(ccv_number)"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .listbike:
            return nil
        case .payment:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
