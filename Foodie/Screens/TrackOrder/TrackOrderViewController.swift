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
    let destinationLocation = CLLocationCoordinate2D(latitude: 41.703516, longitude: 44.789953)

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = 500 // distance changes you want to be informed about (in meters)
        manager.desiredAccuracy = 10 // biggest approximation you tolerate (in meters)
        manager.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
        view.addSubview(mapView)
        
    }
    
    
    // MARK: - Funcs
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyBCEqaJZRBOrOPGVvrK6pMzpFPEdHbQLVU")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes.first as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //method to draw path on map
            self.drawPath(from: polyLineString)
        })
        task.resume()
    }

    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
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
//        fetchRoute(from: destinationLocation, to: currentLocation)   //this line only works for real device
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        marker2.title = "Current Location"
        marker2.snippet = ""
        marker2.map = mapView
    }
}
