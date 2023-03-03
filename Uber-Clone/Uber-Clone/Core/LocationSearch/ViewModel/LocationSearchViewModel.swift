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
    @Published var selected_location_coordinate: CLLocationCoordinate2D?
    
    private let search_completer = MKLocalSearchCompleter()
    var query_fragment: String = "" {
        didSet {
            search_completer.queryFragment = query_fragment
        }
    }
    
    override init() {
        super.init()
        search_completer.delegate = self
        search_completer.queryFragment = query_fragment
    }
    
    func select_location(_ local_search: MKLocalSearchCompletion) {
        location_search(for_local_search_completion: local_search) { response, error in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selected_location_coordinate = coordinate
            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    func location_search(for_local_search_completion local_search: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let search_request = MKLocalSearch.Request()
        search_request.naturalLanguageQuery = local_search.title.appending(local_search.subtitle)
        
        let search = MKLocalSearch(request: search_request)
        search.start(completionHandler: completion)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
