//
//  Test4Det.swift
//  iosApp
//
//  Created by Akashaka on 03/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct ContenttView: View {
    @State private var annotations = [MKPointAnnotation]()
    @State private var multiPolylines = [MKMultiPolyline]()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2146, longitude: 106.8451),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    var body: some View {
        MaptView(annotations: $annotations, multiPolylines: $multiPolylines)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: addMapData)
    }

    func addMapData() {
        // Menambahkan annotation untuk lokasi pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: -6.1754, longitude: 106.8272)
        annotation.title = "Lokasi Pin"
        annotations.append(annotation)

        // Menambahkan multiple polylines
        let polyline1 = MKPolyline(coordinates: [
            CLLocationCoordinate2D(latitude: -6.1754, longitude: 106.8272),
            CLLocationCoordinate2D(latitude: -6.2146, longitude: 106.8451),
        ], count: 2)

        let polyline2 = MKPolyline(coordinates: [
            CLLocationCoordinate2D(latitude: -6.1754, longitude: 106.8272),
            CLLocationCoordinate2D(latitude: -6.2348, longitude: 106.8366),
        ], count: 2)

        multiPolylines.append(MKMultiPolyline([polyline1, polyline2]))
    }
}

struct MaptView: UIViewRepresentable {
    @Binding var annotations: [MKPointAnnotation]
    @Binding var multiPolylines: [MKMultiPolyline]

    func makeUIView(context _: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context _: Context) {
        // Menghapus semua existing annotation dan overlay dari peta
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)

        // Menambahkan annotation ke peta
        uiView.addAnnotations(annotations)

        // Menambahkan multiple polylines ke peta
        uiView.addOverlays(multiPolylines)

        // Menampilkan seluruh annotation dan polyline dalam tampilan yang terlihat
        uiView.showAnnotations(annotations, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MaptView

        init(_ parent: MaptView) {
            self.parent = parent
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let multiPolyline = overlay as? MKMultiPolyline {
                let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

struct ContenttView_Previews: PreviewProvider {
    static var previews: some View {
        ContenttView()
    }
}
