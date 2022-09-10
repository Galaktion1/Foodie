//
//  GetCurrentLocationService.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation
import GoogleMaps
import CoreLocation

class LocationService {
    
    private var coordinators: String?
    
    init(coordinators: String?) {
        self.coordinators = coordinators
    }
    
    convenience init() {
        self.init(coordinators: UserDefaults.standard.value(forKey: "coordinates") as? String)
    }
    
    func getRestaurantLocation() -> CLLocationCoordinate2D {
        
        guard let coordinatesString = coordinators else { return CLLocationCoordinate2D(latitude: 41.703516, longitude: 44.789953)}
        let coordinatesArray = coordinatesString.split(separator: ",")
        let latitude = Double("\(coordinatesArray.first!)") ?? 41.703516
        
        let longtitude = Double("\(coordinatesArray.last!)") ?? 44.789953
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    func getDistanceString(currentLocation: CLLocation ) -> String {
        let restaurantLocation = getRestaurantLocation()
        let distance = CLLocation(latitude: restaurantLocation.latitude, longitude: restaurantLocation.longitude).distance(from: currentLocation)
        
        return (Double(distance) / 1000).format()
    }
}
