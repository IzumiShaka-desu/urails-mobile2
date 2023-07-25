//
//  CustomAnnotation.swift
//  iosApp
//
//  Created by Akashaka on 03/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let image: String
    let placeName: String?
    init(coordinate: CLLocationCoordinate2D, image: String, placeName: String? = nil) {
        self.coordinate = coordinate
        self.image = image
        self.placeName = placeName
    }
}

class CustomPolyline: MKPolyline {
    var color: UIColor?
}
