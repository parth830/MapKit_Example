//
//  MapScreenViewController.swift
//  MapKit_Example
//
//  Created by Ayaan Ruhi on 9/28/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreenViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    // MARK: Check Location Service is enabled or not
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            Alert.showAlert(on: self, with: "Location Services is Disabled", message: "Go to Setting-> Privacy-> Location Services-> ON")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: Check user authorization status
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                startTrackingUserLocation()
            case .authorizedAlways:
                break
            case .denied:
                Alert.showAlert(on: self, with: "Location Access Permission", message: "Allow us to use your location and use app.")
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                break
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    // MARK: Set user location in center of screen
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapview:MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

}

extension MapScreenViewController: CLLocationManagerDelegate {
    
//    // MARK: Update user location when moving
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
//        mapView.setRegion(region, animated: true)
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        // MARK: only request for location if user will move for longer distance
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [ weak self ] (placemarks, error) in
            
            //guard let self = self else { return }
            
            if let _ = error {
                Alert.showAlert(on: self!, with: "Error in Geocode Location", message: error as! String)
                return
            }
            guard let placemark = placemarks?.first else {
                Alert.showAlert(on: self!, with: "Error in placemark", message: error as! String)
                return
            }
         
            let stateName = placemark.administrativeArea ?? ""
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
        
            DispatchQueue.main.async {
                self?.addressLabel.text = "\(streetNumber) \(streetName), \(stateName)"
            }
        }
    }
}


