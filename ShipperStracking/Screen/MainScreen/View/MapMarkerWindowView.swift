//
//  MapMarkerWindowView.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}
class MapMarkerWindowView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var thumbnailView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    func configView(bike:Bike){
      self.titleLabel.text =  bike.store?.name
      self.descriptionLabel.text = bike.store?.description

    }
}
