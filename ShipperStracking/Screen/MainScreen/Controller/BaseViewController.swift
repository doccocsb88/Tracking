//
//  BaseViewController.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showLoadingView(message:String? = nil){
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD showWithStatus:message];
//        svpro
        //        [SVProgressHUD setRingRadius:50];
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        if let message = message{
            SVProgressHUD.show(withStatus: message)
        }else{
            SVProgressHUD.show()

        }

    }
    func hideLoadingView(){
//        SVProgressHUD dismiss
        SVProgressHUD.dismiss()

    }
    func showAlertMessage(title:String,message:String,completion:@escaping ()->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction  = UIAlertAction(title: "OK", style: .default) { (action) in
            completion()
            
        }
        alert.addAction(okAction)
        self .present(alert, animated: true, completion: nil)
    }
}
