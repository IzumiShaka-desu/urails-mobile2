//
//  LocationViewmodel.swift
//  iosApp
//
//  Created by Akashaka on 12/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationViewModel()

    @Published var userLocation: LocationPoint?
    private let locationManager = CLLocationManager()

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getPlaceNameFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            if let placeName = placemark.name {
                completion(placeName)
            } else {
                completion(nil)
            }
        }
    }

    func getPlaceNameOrNearestStreetFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            if let placeName = placemark.name {
                completion(placeName)
            } else if let thoroughfare = placemark.thoroughfare {
                completion(thoroughfare)
            } else {
                completion(nil)
            }
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            var placeName = ""
            getPlaceNameOrNearestStreetFromLocation(location: location) { [self] placeNameOrStreet in
                if let placeNameOrStreet = placeNameOrStreet {
                    print("Place Name or Nearest Street: \(placeNameOrStreet)")
                    placeName = String(placeNameOrStreet)
                    print("placeName = \(placeName)")
                    userLocation = LocationPoint(latitude: latitude, longitude: longitude, placeName: placeName)
                    print(userLocation?.placeName ?? "-")
                } else {
                    print("Failed to get place name or nearest street.")
                }
            }
            userLocation = LocationPoint(latitude: latitude, longitude: longitude, placeName: placeName)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
