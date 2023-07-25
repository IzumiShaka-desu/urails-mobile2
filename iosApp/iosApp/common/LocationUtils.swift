//
//  LocationUtils.swift
//  iosApp
//
//  Created by Akashaka on 03/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//
import MapKit
import shared
import SwiftUI
extension Graph {
    func generatePolylines() -> [MKPolyline] {
        let polylines = edges.map { edge in
            let polyline = CustomPolyline(points: [edge.source, edge.destination].map { item in
                MKMapPoint(
                    CLLocationCoordinate2D(
                        latitude: item.latitude,
                        longitude: item.longitude
                    )
                )
            }, count: 2)
            polyline.color = Color(hex: edge.getLineColor())?.uiColor()
            return polyline
        }
        return polylines
    }
}

// class CustomPolyline : MKPolyline {
//    var coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>
//    var count : Int = 0
//    var color : String = "ff0000"
//    init(coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int, color: String) {
//        self.coordinates = coordinates
//        self.count = count
//        self.color = color
//    }
// }
