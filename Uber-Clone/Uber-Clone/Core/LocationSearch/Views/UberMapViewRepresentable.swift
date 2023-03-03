//
//  UberMapViewRepresentable.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/1/23.
//
import Foundation
import SwiftUI
import MapKit


struct UberMapViewRepresentable: UIViewRepresentable {
    let map_view = MKMapView()
    let location_manager = LocationManager()
    @EnvironmentObject var location_view_model: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        map_view.delegate = context.coordinator
        map_view.isRotateEnabled = false
        map_view.showsUserLocation = true
        map_view.userTrackingMode = .follow
        
        return map_view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = location_view_model.selected_location_coordinate {
            print("DEBUG: Selected coordinates in map view \(coordinate)")
        }
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            parent.map_view.setRegion(region, animated: true)
        }
    }
}
