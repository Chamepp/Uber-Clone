//
//  HomeView.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var show_location_search_view = false
    @State private var map_state = MapViewState.noInput
    @EnvironmentObject var location_view_model: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(map_state: $map_state)
                            .ignoresSafeArea()
                
                
                if map_state == .searchingForLocation {
                    LocationSearchView(map_state: $map_state)
                } else if map_state == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                map_state = .searchingForLocation
                            }
                        }
                }
                
                
                MapViewActionButton(map_state: $map_state)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if map_state == .locationSelected || map_state == .polylineAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$user_location) { location in
            if let location = location {
                location_view_model.user_location = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
