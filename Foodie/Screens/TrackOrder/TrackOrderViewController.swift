//
//  TrackOrderViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 02.09.22.
//

import UIKit
import GoogleMaps
import CoreLocation

class TrackOrderViewController: UIViewController {
    
    // MARK: - Variables
    let manager = CLLocationManager()
    var mapView = GMSMapView()
    var destinationLocation = CLLocationCoordinate2D()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        convertStringToCLLocationCoordinates()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = 500 // distance changes you want to be informed about (in meters)
        manager.desiredAccuracy = 10 // biggest approximation you tolerate (in meters)
        manager.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
        view.addSubview(mapView)
    }
    
    private func convertStringToCLLocationCoordinates() {
        let coordinators = UserDefaults.standard.value(forKey: "coordinates") as? String
        
        guard let coordinatesString = coordinators else { return }
        let coordinatesArray = coordinatesString.split(separator: ",")
        let latitude = Double("\(coordinatesArray.first!)") ?? 41.703516
        
        let longtitude = Double("\(coordinatesArray.last!)") ?? 44.789953
        
        destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
     
}


extension TrackOrderViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first?.coordinate else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: destinationLocation.latitude, longitude: destinationLocation.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
       
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        marker.title = "MCDonalds"
        marker.snippet = "Tbilisi, Rustaveli"
        marker.map = mapView
        FetchRouteAPIService.shared.fetchRoute(from: destinationLocation, to: currentLocation, for: mapView)  //this line only works for real device
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        marker2.title = "Current Location"
        marker2.snippet = ""
        marker2.map = mapView
    }
}
