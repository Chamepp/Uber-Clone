//
//  HomeView.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var show_location_search_view = false
    
    var body: some View {
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                        .ignoresSafeArea()
            
            
            if show_location_search_view {
                LocationSearchView(show_location_search_view: $show_location_search_view)
            } else {
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            show_location_search_view.toggle()
                        }
                    }
            }
            
            
            MapViewActionButton(show_location_search_view: $show_location_search_view)
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
