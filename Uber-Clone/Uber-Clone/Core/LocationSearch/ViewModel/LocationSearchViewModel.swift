//
//  LocationSearchViewModel.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/3/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selected_uber_location: UberLocation?
    @Published var pickup_time: String?
    @Published var dropoff_time: String?
    
    private let search_completer = MKLocalSearchCompleter()
    var query_fragment: String = "" {
        didSet {
            search_completer.queryFragment = query_fragment
        }
    }
    
    var user_location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        search_completer.delegate = self
        search_completer.queryFragment = query_fragment
    }
    
    func select_location(_ local_search: MKLocalSearchCompletion) {
        location_search(for_local_search_completion: local_search) { response, error in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selected_uber_location = UberLocation(title: local_search.title, coordinate: coordinate)
            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    func location_search(for_local_search_completion local_search: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let search_request = MKLocalSearch.Request()
        search_request.naturalLanguageQuery = local_search.title.appending(local_search.subtitle)
        
        let search = MKLocalSearch(request: search_request)
        search.start(completionHandler: completion)
    }
    
    func compute_ride_price(forType type: RideType) -> Double {
        guard let destination_coordinate = selected_uber_location?.coordinate else { return 0.0 }
        guard let user_coordinate = self.user_location else { return 0.0 }
        
        let user_location = CLLocation(latitude: user_coordinate.latitude, longitude: user_coordinate.longitude)
        let destination = CLLocation(latitude: destination_coordinate.latitude, longitude: destination_coordinate.longitude)
        let trip_distance_in_meters = user_location.distance(from: destination)
        return type.compute_price(for: trip_distance_in_meters)

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
            self.configure_pickup_and_dropoff_times(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configure_pickup_and_dropoff_times(with expected_travel_time: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickup_time = formatter.string(from: Date())
        dropoff_time = formatter.string(from: Date() + expected_travel_time)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
