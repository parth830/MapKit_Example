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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
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
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                centerViewOnUserLocation()
                locationManager.startUpdatingLocation()
                break
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
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            mapView.setRegion(region, animated: true)
        }
    }

}

extension MapScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


