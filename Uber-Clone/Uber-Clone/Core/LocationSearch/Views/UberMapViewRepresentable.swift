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
        print("DEBUG: Map state is \(map_state)")
        
        switch map_state {
        case .noInput:
            context.coordinator.clear_map_view_and_recenter_on_user_location()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = location_view_model.selected_location_coordinate {
                context.coordinator.add_and_select_annotation(with_coordinate: coordinate)
                context.coordinator.configure_polyline(with_destination_coordinate: coordinate)
            }
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
            self.parent.map_view.addAnnotation(anno)
            self.parent.map_view.selectAnnotation(anno, animated: true)
            
            parent.map_view.showAnnotations(parent.map_view.annotations, animated: true)
        }
        
        func configure_polyline(with_destination_coordinate coordinate: CLLocationCoordinate2D) {
            guard let user_location_coordinate = self.user_location_coordinate else { return }

            get_destination_route(from: user_location_coordinate, to: coordinate) { route in
                self.parent.map_view.addOverlay(route.polyline)
            }
        }
        
        func get_destination_route(from user_location: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
            let user_place_mark = MKPlacemark(coordinate: user_location)
            let destination_place_mark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: user_place_mark)
            request.destination = MKMapItem(placemark: destination_place_mark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else { return }
                completion(route)
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
