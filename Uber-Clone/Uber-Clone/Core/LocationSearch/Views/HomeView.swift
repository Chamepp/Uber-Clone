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
    
    var body: some View {
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
