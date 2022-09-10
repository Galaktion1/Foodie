//
//  FetchRouteAPIService.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 08.09.22.
//

import Foundation
import GoogleMaps
import CoreLocation

class FetchRouteAPIService {

    static let shared = FetchRouteAPIService()
    
    private init() {}
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, for mapView: GMSMapView) {
        
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
            self.drawPath(from: polyLineString, mapView: mapView)
        })
        task.resume()
    }

    private func drawPath(from polyStr: String, mapView: GMSMapView){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }
}
