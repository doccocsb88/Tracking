//
//  ViewController.swift
//  ShipperStracking
//
//  Created by Apple on 3/27/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: BaseViewController,CLLocationManagerDelegate, PaymentDelegate {
    let locationManager = CLLocationManager()
    var mapView:GMSMapView!
    var bikeViewModel:BikeViewModel!
    var rentInfoView:RentInfoView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self .setupView()
        bikeViewModel = BikeViewModel { [unowned self] (state) in
            if !state{
                self.showAlertMessage(title: "Error", message: ErrorMessage.noData.rawValue, completion: {
                    self.bikeViewModel.fetchBikes(mapView: self.mapView)

                })
            }
            
        }
        rentInfoView = RentInfoView.instanceFromNib() as! RentInfoView
        showLoadingView(message: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bikeViewModel.fetchBikes(mapView: mapView)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
}
extension ViewController{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        mapView.camera =  GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 10.0)
        locationManager.stopUpdatingLocation()
        hideLoadingView()
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()

        }
        
    }

}
extension ViewController{
    func setupView(){
        self.setupNavigator()
        self.initMapView()
        self.getCurrentLocation()
    }
    func setupNavigator(){
        self.navigationItem.title = "bBer"
    }
    func initMapView(){
        let camera = GMSCameraPosition.camera(withLatitude: 10.819164, longitude: 106.688876, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self;
//        view = mapView
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.frame = view.bounds
        self.view .addSubview(mapView)
    }
    func showPaymentView(bike:Bike){
        let paymentViewController = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        paymentViewController.delegate = self
        paymentViewController.bike = bike
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func addRentInfoView(){
        rentInfoView.removeFromSuperview()
        rentInfoView.reloadView()
        if RentInfo.shared.isBooked() {
            rentInfoView.translatesAutoresizingMaskIntoConstraints = false
            self.view .addSubview(rentInfoView)

            rentInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: 0).isActive = true
            rentInfoView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                               constant: 0).isActive = true
            rentInfoView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                constant: 0).isActive = true
            rentInfoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }
}
extension ViewController: GMSMapViewDelegate,MapMarkerDelegate{
    func didTapInfoButton(data: NSDictionary) {
        
    }
    
 
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
        guard let bike = marker.userData as? Bike else
        {
            return
        }
        showPaymentView(bike:bike)
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        bikeViewModel.locationMarker = marker
        bikeViewModel.infoWindow.removeFromSuperview()
        bikeViewModel.loadInfoView()
        guard let bike = marker.userData as? Bike else
        {
            return nil
        }
        bikeViewModel.configInfoView(bike:bike)
        return  bikeViewModel.infoWindow
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
         bikeViewModel.infoWindow.removeFromSuperview()
    }

}
extension ViewController{
    func didFinishedPayment() {
        addRentInfoView()
    }
}
