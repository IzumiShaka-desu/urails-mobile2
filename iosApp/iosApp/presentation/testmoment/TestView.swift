//
//  TestView.swift
//  iosApp
//
//  Created by Akashaka on 10/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import shared
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var graphState: AppState<Graph>

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context _: Context) {
        if let graph = graphState.data {
            let polylines = generatePolylines(from: graph)
            mapView.addOverlays(polylines)
            let stations = graph.stations
            mapView.addAnnotations(stations.map { station in
                let annotation = StationAnnotation(
                    title: station.stationName,
                    coordinate: CLLocationCoordinate2D(
                        latitude: station.latitude,
                        longitude: station.longitude
                    )
                )
                return annotation
            })
        } else {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func generatePolylines(from graph: Graph) -> [MKPolyline] {
        var polylines: [MKPolyline] = []

        for edge in graph.edges {
            let startCoordinate = CLLocationCoordinate2D(latitude: edge.source.latitude, longitude: edge.source.longitude)
            let destinationCoordinate = CLLocationCoordinate2D(latitude: edge.destination.latitude, longitude: edge.destination.longitude)

            let coordinates: [CLLocationCoordinate2D] = [startCoordinate, destinationCoordinate]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            polylines.append(polyline)
        }

        return polylines
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }

            return MKOverlayRenderer()
        }
    }
}

class StationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
