//
//  Test8View.swift
//  iosApp
//
//  Created by Akashaka on 15/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct ContentttView: View {
    @State private var annotations = [MKPointAnnotation]()
    @State private var polylinePoints = [CLLocationCoordinate2D]()
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var zoomLevel: Double = 0.02
    private var region: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    var body: some View {
        MapTView(
            annotations: $annotations,
            polylinePoints: $polylinePoints,
            userTrackingMode: $userTrackingMode,
            zoomLevel: $zoomLevel,
            initialRegion: region
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: addMapData)
    }

    func addMapData() {
        // Menambahkan annotation untuk lokasi pin di Jakarta
        let jakartaCoordinate = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
        let annotation = MKPointAnnotation()
        annotation.coordinate = jakartaCoordinate
        annotation.title = "Jakarta"
        annotations.append(annotation)

        // Menambahkan polyline di sekitar Jakarta
        polylinePoints.append(CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456))
        polylinePoints.append(CLLocationCoordinate2D(latitude: -6.1901, longitude: 106.8489))
        polylinePoints.append(CLLocationCoordinate2D(latitude: -6.1821, longitude: 106.8350))
        polylinePoints.append(CLLocationCoordinate2D(latitude: -6.2006, longitude: 106.8286))
        polylinePoints.append(CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456))
    }
}

struct MapTView: UIViewRepresentable {
    @Binding var annotations: [MKPointAnnotation]
    @Binding var polylinePoints: [CLLocationCoordinate2D]
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var zoomLevel: Double
    let initialRegion: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.setRegion(initialRegion, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context _: Context) {
        // Menghapus semua existing annotation dan overlay dari peta
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)

        // Menambahkan annotation ke peta
        uiView.addAnnotations(annotations)

        // Menambahkan polyline ke peta
        let polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
        uiView.addOverlay(polyline)

        // Mengatur mode tracking pengguna pada peta
        uiView.userTrackingMode = userTrackingMode

        // Mengatur tingkat zoom pada peta
//        let region = MKCoordinateRegion(center: uiView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        uiView.showsUserLocation = true

//        uiView.setRegion(region, animated: true)
        // Mengatur tingkat zoom pada peta
//            let camera = MKMapCamera(lookingAtCenter: uiView.centerCoordinate, fromEyeCoordinate: uiView.centerCoordinate, eyeAltitude: zoomLevel)
//            uiView.setCamera(camera, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapTView

        init(_ parent: MapTView) {
            self.parent = parent
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

struct ContentttView_Previews: PreviewProvider {
    static var previews: some View {
        ContentttView()
    }
}
