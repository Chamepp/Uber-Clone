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
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
