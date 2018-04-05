//
//  RentInfoView.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RentInfoView: UIView {

    @IBOutlet weak var bikeIdLabel: UILabel!
    
    @IBOutlet weak var codeLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "RentInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    func reloadView(){
        if RentInfo.shared.isBooked() {
            bikeIdLabel.text = RentInfo.shared.bikeId ?? ""
            codeLabel.text = RentInfo.shared.code ?? ""
        }
    }
}
