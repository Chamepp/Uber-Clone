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
    let location_manager = LocationManager.shared
    @Binding var map_state: MapViewState
    @EnvironmentObject var location_view_model: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        map_view.delegate = context.coordinator
        map_view.isRotateEnabled = false
        map_view.showsUserLocation = true
        map_view.userTrackingMode = .follow
        
        return map_view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch map_state {
            case .noInput:
                context.coordinator.clear_map_view_and_recenter_on_user_location()
                break
            case .searchingForLocation:
                break
            case .locationSelected:
                if let coordinate = location_view_model.selected_uber_location?.coordinate {
                    print("DEBUG: Adding stuff to map")
                    context.coordinator.add_and_select_annotation(with_coordinate: coordinate)
                    context.coordinator.configure_polyline(with_destination_coordinate: coordinate)
                }
                break
            case .polylineAdded:
                break
        }
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var user_location_coordinate: CLLocationCoordinate2D?
        var current_region: MKCoordinateRegion?
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.user_location_coordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.current_region = region
            parent.map_view.setRegion(region, animated: true)
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func add_and_select_annotation(with_coordinate coordinate: CLLocationCoordinate2D) {
            parent.map_view.removeAnnotations(parent.map_view.annotations)
            parent.map_view.removeOverlays(parent.map_view.overlays)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.map_view.addAnnotation(anno)
            parent.map_view.selectAnnotation(anno, animated: true)
            
        }
        
        func configure_polyline(with_destination_coordinate coordinate: CLLocationCoordinate2D) {
            guard let user_location_coordinate = self.user_location_coordinate else { return }

            parent.location_view_model.get_destination_route(from: user_location_coordinate, to: coordinate) { route in
                self.parent.map_view.addOverlay(route.polyline)
                self.parent.map_state = .polylineAdded
                let rect = self.parent.map_view.mapRectThatFits(
                    route.polyline.boundingMapRect,
                    edgePadding: .init(
                        top: 64,
                        left: 32,
                        bottom: 500,
                        right: 32
                    )
                )
                self.parent.map_view.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clear_map_view_and_recenter_on_user_location() {
            parent.map_view.removeAnnotations(parent.map_view.annotations)
            parent.map_view.removeOverlays(parent.map_view.overlays)
            
            if let current_region = current_region {
                parent.map_view.setRegion(current_region, animated: true)
            }
        }
    }
}
