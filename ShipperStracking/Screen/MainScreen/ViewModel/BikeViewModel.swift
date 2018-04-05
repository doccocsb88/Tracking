//
//  MapViewModel.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import GoogleMaps


final class BikeViewModel{

    let callback: (Bool) -> ()
    init(callback: @escaping (Bool) -> ()) {
        self.callback = callback
        infoWindow = self.loadNiB()

    }
    var infoWindow = MapMarkerWindowView()
    var locationMarker : GMSMarker? = GMSMarker()

    var bikes: [Bike] = [Bike]()
    var isLoaded:Bool = false
    
    func fetchBikes(mapView:GMSMapView) {
        if isLoaded{
            return
        }
        APISerives.getlistBikes {[weak self] (response) in
            print("response :\(response)")
            guard let strongSelf = self else{
                return
            }
            guard let json = response as? NSDictionary else{
                strongSelf.callback(false)
                return
            }
            guard let bikes = json.object(forKey: "bikes") as? NSArray else{
                strongSelf.callback(false)
                return
            }
            mapView.clear()
            strongSelf.bikes.removeAll()
            for dict in bikes {
                if let bikeDict = dict as? NSDictionary{
                    let bike = Bike(json: bikeDict)
//                    print("\(bike.codinate) \(bike.price) \(bike.store)")
//                    self.addMaker(bike: bike)
                    if let _ = bike.codinate{
                        strongSelf.bikes.append(bike)
                    }
                }
            }
            strongSelf.isLoaded = true;
            strongSelf.addBikeToMapView(mapView: mapView)
            strongSelf.focusMapToShowAllMarkers(mapView: mapView)
        }
    }
    func addBikeToMapView(mapView:GMSMapView){
        
        for bike in bikes{
            let marker = GMSMarker()
            marker.position = bike.codinate!
            marker.title = "..."
            marker.snippet = "..."
            marker.map = mapView
            marker.icon = UIImage(named: "ic_marker_bike")
            marker.userData = bike
        }
    }
    func focusMapToShowAllMarkers(mapView:GMSMapView) {
        guard let firstLocation = bikes.first?.codinate else{
            return
        }
        var bounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
        
        for bike in bikes {
            bounds = bounds.includingCoordinate(bike.codinate!)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
        //        self.mapView.animate(cameraUpdate: update)
        mapView.animate(with: update)
    }
    
    func configInfoView(bike:Bike){
        self.infoWindow.configView(bike: bike)
    }
    func loadNiB() -> MapMarkerWindowView {
        let infoWindow = MapMarkerWindowView.instanceFromNib() as! MapMarkerWindowView
        return infoWindow
    }
    func loadInfoView(){
        self.infoWindow = loadNiB()
    }
}

