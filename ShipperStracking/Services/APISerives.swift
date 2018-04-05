//
//  APISerives.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
//http://blog.getpostman.com/2016/01/26/using-a-mocking-service-to-create-postman-collections/

class APISerives{
    static func getlistBikes(completion:@escaping (_ json: AnyObject?)->Void) {
//        Alamofire.request(APIRouter.login(email: email, password: password))
//            .responseJSONDecodable { (response: DataResponse<User>) in
//                completion(response.result)
        Alamofire.request(UserEndpoint.listbike).responseJSON  { (response:DataResponse<Any>) in
            print(response)
            
            switch(response.result) {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                guard let bikes = response.object(forKey: "bikes") as? NSArray else{
                    return
                }
                for dict in bikes {
                //example if there is an id
                    if let bikeDict = dict as? NSDictionary{
                       let bike = Bike(json: bikeDict)
                        print("\(bike.codinate) \(bike.price) \(bike.store)")
                        
                    }
                }
                completion(response)
            case .failure(let error):
                completion(nil)

                print("Request failed with error: \(error)")
            }
        }
    
    }
    static func payment(cardNumber:String, expiryDate:String,cardHolder:String,ccv_number:String, completion:@escaping (_ json: AnyObject?)->Void){
        Alamofire.request(UserEndpoint.payment(cardNumber: cardNumber, expiryDate: expiryDate, cardHolder: cardHolder, ccv_number: ccv_number)).responseJSON  { (response:DataResponse<Any>) in
            print(response)
            
            switch(response.result) {
            case .success(let JSON):
                print(" payment Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                completion(response)

            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(nil)

            }
        }
    }
    static func demoSuccessPayment(){
        payment(cardNumber: "123456789", expiryDate: "03_20", cardHolder: "vu_van_hai", ccv_number: "113") { (response) in
            
        }
    }
    static func demoFailurePayment(){
        payment(cardNumber: "123456780", expiryDate: "03_20", cardHolder: "vu_van_hai", ccv_number: "113") { (response) in
            
        }
    }
}
