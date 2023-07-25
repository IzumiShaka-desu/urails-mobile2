//
//  Test6View.swift
//  iosApp
//
//  Created by Akashaka on 12/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct Content5View: View {
    @State private var annotations = [MKAnnotation]()
    @State private var polylines = [MKPolyline]()
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var zoomLevel: Double = 0.002
    let initialRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))

    var body: some View {
        MapTTView(annotations: $annotations, polylines: $polylines, userTrackingMode: $userTrackingMode, zoomLevel: $zoomLevel, initialRegion: initialRegion)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: addMapData)
    }

    func addMapData() {
        // Menambahkan annotation untuk lokasi pin di Jakarta
        let jakartaCoordinate = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = jakartaCoordinate
//        annotation.title = "Jakarta"
        let annotation = CustomAnnotation(
            coordinate: jakartaCoordinate,
            image: "icon_station_circle"
        )
        annotations.append(annotation)

        // Menambahkan polyline di sekitar Jakarta
        let polyline1 = CustomPolyline(coordinates: [
            CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
            CLLocationCoordinate2D(latitude: -6.1901, longitude: 106.8489),
        ], count: 2)
        polyline1.color = .red
        polylines.append(polyline1)

        let polyline2 = CustomPolyline(coordinates: [
            CLLocationCoordinate2D(latitude: -6.1901, longitude: 106.8489),
            CLLocationCoordinate2D(latitude: -6.1901, longitude: 107.8489),
        ], count: 2)
        polyline2.color = .green
        polylines.append(polyline2)
    }
}

struct MapTTView: UIViewRepresentable {
    @Binding var annotations: [MKAnnotation]
    @Binding var polylines: [MKPolyline]
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

        // Menambahkan polylines ke peta
        uiView.addOverlays(polylines)

        // Mengatur mode tracking pengguna pada peta
        uiView.userTrackingMode = userTrackingMode

        // Mengatur tingkat zoom pada peta
//        let camera = MKMapCamera(lookingAtCenter: uiView.centerCoordinate, fromEyeCoordinate: uiView.centerCoordinate, eyeAltitude: zoomLevel)
//        uiView.setCamera(camera, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapTTView

        init(_ parent: MapTTView) {
            self.parent = parent
        }

        func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? CustomAnnotation else {
                return nil
            }

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: annotation.image)

            // Mengatur ukuran marker
            let scale = CGFloat(0.45) // Mengatur faktor skala sesuai kebutuhan
            let size = CGSize(
                width: annotationView.image!.size.width * scale,
                height: annotationView.image!.size.height * scale
            )
            annotationView.transform = CGAffineTransform(
                scaleX: size.width / annotationView.image!.size.width,
                y: size.height / annotationView.image!.size.height
            )

            // Mengatur offset agar marker ditampilkan di atas titik yang sebenarnya
            annotationView.centerOffset = CGPoint(x: 0, y: -size.height / 2)
            return annotationView
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? CustomPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = polyline.color
                renderer.lineWidth = 3
                return renderer
            }
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

struct Content5View_Previews: PreviewProvider {
    static var previews: some View {
        Content5View()
    }
}
