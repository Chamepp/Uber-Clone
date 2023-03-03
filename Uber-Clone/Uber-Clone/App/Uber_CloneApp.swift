//
//  Uber_CloneApp.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 2/25/23.
//

import SwiftUI

@main
struct Uber_CloneApp: App {
    
    @StateObject var location_view_model = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(location_view_model)
        }
    }
}
